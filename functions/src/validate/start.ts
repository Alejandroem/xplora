import { onCall, HttpsError } from "firebase-functions/v2/https";
import {
  getFirestore,
  FieldValue,
  Timestamp,
} from "firebase-admin/firestore";
import { StartRequest, StartResponse } from "./types";

export const validateStart = onCall<StartRequest, Promise<StartResponse>>(
  { invoker: "public" },
  async (request) => {
    const db = getFirestore();

    // ── Step 1: Auth ──────────────────────────────────────────────────────
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Authentication required.");
    }
    const uid = request.auth.uid;
    const data = request.data;

    // ── Step 2: Load entity ───────────────────────────────────────────────
    // Currently only PLACE is supported.
    // TODO: QUEST → load quests/{scopeId} then its associated place if needed
    // TODO: EVENT → load events/{scopeId} and its place/geo override
    if (data.scopeType !== "PLACE") {
      throw new HttpsError(
        "unimplemented",
        `scopeType "${data.scopeType}" is not yet supported.`
      );
    }

    const placeSnap = await db.doc(`places/${data.scopeId}`).get();
    if (!placeSnap.exists) {
      throw new HttpsError("not-found", "Place not found.");
    }
    const place = placeSnap.data()!;

    // ── Step 3: Determine targetGeo ───────────────────────────────────────
    // PLACE: geo.geopoint field
    // EVENT: geoOverride if present, else place geo (not implemented yet)
    const geopoint = place.geo?.geopoint;
    if (!geopoint) {
      throw new HttpsError("failed-precondition", "Place has no geo data.");
    }
    const targetGeo = {
      lat: geopoint.latitude as number,
      lng: geopoint.longitude as number,
    };

    // ── Step 4: Load config ───────────────────────────────────────────────
    // Priority: place.validationConfigId → globalDefault doc
    // TODO: for QUEST/EVENT, check entity.validationConfigId first
    const configId: string | undefined = place.validationConfigId;
    let config: FirebaseFirestore.DocumentData | null = null;

    if (configId) {
      const configSnap = await db.doc(`validationConfigs/${configId}`).get();
      if (configSnap.exists) {
        config = { id: configSnap.id, ...configSnap.data()! };
      }
    }

    if (!config) {
      // Fallback to the globalDefault doc
      const globalSnap = await db
        .doc("validationConfigs/globalDefault")
        .get();
      if (!globalSnap.exists) {
        throw new HttpsError(
          "failed-precondition",
          "No validation config available for this place."
        );
      }
      config = { id: globalSnap.id, ...globalSnap.data()! };
    }

    // ── Step 5: Enforce availability ──────────────────────────────────────
    // PLACE: status must be "active"
    // TODO: EVENT — check schedule window and [startTime, endTime] with grace
    if (place.status !== "active") {
      throw new HttpsError("failed-precondition", "Place is not active.");
    }

    // Speed check (server-side enforcement using the submitted locationSample)
    if (
      config.maxSpeedMps != null &&
      data.locationSample.speedMps != null &&
      data.locationSample.speedMps > config.maxSpeedMps
    ) {
      throw new HttpsError(
        "failed-precondition",
        "Moving too fast for check-in."
      );
    }

    // Mock location check
    if (config.denyIfMockLocationSuspected && data.locationSample.isMocked) {
      throw new HttpsError("failed-precondition", "Mock location detected.");
    }

    // ── Step 6: Enforce completion constraints ────────────────────────────
    // Completion doc: users/{uid}/completions/PLACE_{scopeId}
    const completionRef = db.doc(
      `users/${uid}/completions/PLACE_${data.scopeId}`
    );
    const completionSnap = await completionRef.get();

    if (completionSnap.exists) {
      const completion = completionSnap.data()!;

      // oneTimeOnly: deny if already consumed
      if (config.oneTimeOnly && completion.oneTimeConsumed === true) {
        throw new HttpsError(
          "failed-precondition",
          "This check-in can only be completed once."
        );
      }

      // cooldown: deny if cooldownUntil is still in the future
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
    }

    // ── Steps 7 & 8: Transaction — session limit check + session creation ─
    // Both run in a single transaction to prevent race conditions from
    // simultaneous /start calls by the same user.
    const sessionsRef = db.collection(`users/${uid}/validationSessions`);
    const newSessionRef = sessionsRef.doc(); // pre-generate ID before tx
    const expiresAtMs = Date.now() + (config.sessionTtlSec as number) * 1000;
    const expiresAt = Timestamp.fromMillis(expiresAtMs);

    await db.runTransaction(async (tx) => {
      // Step 7: Count active sessions for this user
      const activeQuery = await tx.get(
        sessionsRef.where("status", "in", [
          "CREATED",
          "LOCKING",
          "IN_PROGRESS",
          "READY_TO_COMPLETE",
        ])
      );
      if (activeQuery.size >= (config!.maxActiveSessionsPerUser as number)) {
        throw new HttpsError(
          "resource-exhausted",
          "Maximum active check-in sessions reached."
        );
      }

      // Step 8: Create session doc with status LOCKING
      tx.set(newSessionRef, {
        uid,
        scope: {
          scopeType: data.scopeType,
          placeId: data.scopeId,
        },
        mode: data.mode,
        status: "LOCKING",
        // Full config snapshot — server uses this for all subsequent validation.
        // Decouples session from live config changes mid-session.
        configSnapshot: config,
        target: {
          lat: targetGeo.lat,
          lng: targetGeo.lng,
          radiusM: config!.radiusM,
        },
        timing: {
          createdAt: FieldValue.serverTimestamp(),
          expiresAt,
          lockedAt: null,
          lastPingAt: null,
          completedAt: null,
        },
        sampling: {
          acceptedSampleCount: 0,
          lastAccepted: null,
        },
        // TODO: populate for DWELL mode — requiredSec should read from a
        // dedicated dwellRequiredSec field on ValidationConfig (to be added).
        ...(data.mode === "DWELL" && {
          dwell: {
            requiredSec: 0,
            accumulatedSec: 0,
            totalOutsideSec: 0,
            consecutiveOutsideSec: 0,
          },
        }),
        antiCheat: {
          codeAttempts: 0,
          codeAttemptWindowStartAt: null,
          lastRejectReason: null,
          deviceIdHash: data.deviceInfo?.deviceIdHash ?? null,
        },
        // Initial location sample stored for audit — clientTs is never trusted
        initialSample: {
          lat: data.locationSample.lat,
          lng: data.locationSample.lng,
          accuracyM: data.locationSample.accuracyM,
          speedMps: data.locationSample.speedMps,
          clientTs: Timestamp.fromMillis(data.locationSample.clientTs),
          isMocked: data.locationSample.isMocked,
        },
        result: {
          rewardTxnId: null,
          completionReason: null,
        },
      });
    });

    // ── Step 9: Return ────────────────────────────────────────────────────
    return {
      sessionId: newSessionRef.id,
      status: "LOCKING",
      target: {
        lat: targetGeo.lat,
        lng: targetGeo.lng,
        radiusM: config.radiusM as number,
      },
      requiresQrOrCode: (config.requiresQrOrCode as boolean) ?? false,
      expiresAt: expiresAtMs,
    };
  }
);
