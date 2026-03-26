import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { CompleteRequest, CompleteResponse } from "./types";

const FRESH_PING_THRESHOLD_SEC = 40;

export const validateComplete = onCall<CompleteRequest, Promise<CompleteResponse>>(
  { invoker: "public" },
  async (request) => {
    const db = getFirestore();

    // ── Step 1: Auth ──────────────────────────────────────────────────────
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Authentication required.");
    }
    const uid = request.auth.uid;
    const data = request.data;

    // ── Step 2: Load & validate session ───────────────────────────────────
    const sessionRef = db.doc(
      `users/${uid}/validationSessions/${data.sessionId}`
    );
    const sessionSnap = await sessionRef.get();
    if (!sessionSnap.exists) {
      throw new HttpsError("not-found", "Session not found.");
    }
    const session = sessionSnap.data()!;
    const config = session.configSnapshot;

    if (!["IN_PROGRESS", "READY_TO_COMPLETE"].includes(session.status)) {
      throw new HttpsError(
        "failed-precondition",
        `Session status is ${session.status}, expected IN_PROGRESS or READY_TO_COMPLETE.`
      );
    }

    const expiresAt = (session.timing.expiresAt as Timestamp).toDate();
    if (expiresAt <= new Date()) {
      await sessionRef.update({ status: "EXPIRED" });
      throw new HttpsError("failed-precondition", "Session expired.");
    }

    // ── Step 3: QR/Code verification ──────────────────────────────────────
    // TODO: if config.requiresQrOrCode:
    //   verify token exists, not expired, matches scope, not redeemed

    // ── Step 4: Final location requirement ────────────────────────────────
    const lastPingAt = session.timing.lastPingAt as Timestamp | null;
    if (!lastPingAt) {
      throw new HttpsError(
        "failed-precondition",
        "No ping received for this session."
      );
    }
    const secondsSinceLastPing =
      (Date.now() - lastPingAt.toDate().getTime()) / 1000;
    if (secondsSinceLastPing > FRESH_PING_THRESHOLD_SEC) {
      throw new HttpsError("failed-precondition", "Location data too stale.");
    }

    if (config.requireInsideOnComplete) {
      const lastAccepted = session.sampling.lastAccepted;
      if (
        !lastAccepted ||
        (lastAccepted.distanceM as number) > (config.radiusM as number)
      ) {
        throw new HttpsError(
          "failed-precondition",
          "Last known position is outside the required area."
        );
      }
    }

    // ── Step 5: Transaction — one-time/cooldown re-check + completion ─────
    const completionRef = db.doc(
      `users/${uid}/completions/PLACE_${session.scope.placeId}`
    );
    const completedAtMs = Date.now();
    const completedAt = Timestamp.fromMillis(completedAtMs);

    let timesCompleted = 1;
    let cooldownUntilMs: number | null = null;

    await db.runTransaction(async (tx) => {
      const completionSnap = await tx.get(completionRef);

      if (completionSnap.exists) {
        const completion = completionSnap.data()!;

        // Race safety: re-check oneTimeOnly
        if (config.oneTimeOnly && completion.oneTimeConsumed === true) {
          throw new HttpsError(
            "failed-precondition",
            "This check-in can only be completed once."
          );
        }

        // Race safety: re-check cooldown
        if (completion.cooldownUntil) {
          const cooldownUntil = (
            completion.cooldownUntil as Timestamp
          ).toDate();
          if (cooldownUntil > new Date()) {
            throw new HttpsError(
              "failed-precondition",
              "Check-in is on cooldown."
            );
          }
        }

        timesCompleted = ((completion.timesCompleted as number) ?? 0) + 1;
      }

      if (
        config.cooldownSec != null &&
        (config.cooldownSec as number) > 0
      ) {
        cooldownUntilMs =
          completedAtMs + (config.cooldownSec as number) * 1000;
      }

      // Mark session COMPLETED
      tx.update(sessionRef, {
        status: "COMPLETED",
        "timing.completedAt": completedAt,
        "result.completionReason": "CHECKIN",
      });

      // Update/create completion record
      const completionUpdate: Record<string, unknown> = {
        timesCompleted,
        lastCompletedAt: completedAt,
      };
      if (cooldownUntilMs != null) {
        completionUpdate["cooldownUntil"] = Timestamp.fromMillis(cooldownUntilMs);
      }
      if (config.oneTimeOnly) {
        completionUpdate["oneTimeConsumed"] = true;
      }
      tx.set(completionRef, completionUpdate, { merge: true });
    });

    // ── Step 6: Redeem QR token ───────────────────────────────────────────
    // TODO: if qrTokenId used: set redeemedBy=uid, redeemedAt=now, redeemedCount=1

    // ── Step 7: Reward ledger ─────────────────────────────────────────────
    // TODO: create reward ledger transaction (XP, badges, etc.)

    // ── Step 8: Return ────────────────────────────────────────────────────
    return {
      success: true,
      completedAt: completedAtMs,
      timesCompleted,
      cooldownUntil: cooldownUntilMs,
    };
  }
);
