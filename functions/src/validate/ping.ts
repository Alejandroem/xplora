import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue, Timestamp } from "firebase-admin/firestore";
import { PingRequest, PingResponse } from "./types";

// Haversine — returns distance in metres between two lat/lng points
function haversineM(
  lat1: number,
  lng1: number,
  lat2: number,
  lng2: number
): number {
  const R = 6371000;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLng = ((lng2 - lng1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLng / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

function progressPercent(
  session: FirebaseFirestore.DocumentData,
  config: FirebaseFirestore.DocumentData
): number {
  return Math.min(
    (session.sampling.acceptedSampleCount as number) /
      (config.minAcceptedSamplesToLock as number),
    1.0
  );
}

export const validatePing = onCall<PingRequest, Promise<PingResponse>>(
  { invoker: "public" },
  async (request) => {
    const db = getFirestore();

    // ── Step 1: Auth ──────────────────────────────────────────────────────
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Authentication required.");
    }
    const uid = request.auth.uid;
    const data = request.data;

    // ── Step 1 cont: Load session ─────────────────────────────────────────
    const sessionRef = db.doc(
      `users/${uid}/validationSessions/${data.sessionId}`
    );
    const sessionSnap = await sessionRef.get();
    if (!sessionSnap.exists) {
      throw new HttpsError("not-found", "Session not found.");
    }
    const session = sessionSnap.data()!;
    const config = session.configSnapshot;

    // Verify not expired
    const expiresAt = (session.timing.expiresAt as Timestamp).toDate();
    if (expiresAt <= new Date()) {
      await sessionRef.update({ status: "EXPIRED" });
      throw new HttpsError("failed-precondition", "Session expired.");
    }

    // Verify not already terminal
    const terminalStatuses = ["COMPLETED", "EXPIRED", "FAILED"];
    if (terminalStatuses.includes(session.status)) {
      throw new HttpsError(
        "failed-precondition",
        `Session already ${(session.status as string).toLowerCase()}.`
      );
    }

    const timeRemainingSec = Math.max(
      0,
      Math.floor((expiresAt.getTime() - Date.now()) / 1000)
    );

    // ── Step 2: Accuracy gate ─────────────────────────────────────────────
    if (data.locationSample.accuracyM > (config.minAccuracyM as number)) {
      await sessionRef.update({
        "timing.lastPingAt": FieldValue.serverTimestamp(),
        "antiCheat.lastRejectReason": "accuracy_too_low",
      });
      return {
        status: session.status as string,
        inside: false,
        distanceM: -1,
        progressPercent: progressPercent(session, config),
        timeRemainingSec,
        rejectReason: "accuracy_too_low",
      };
    }

    // ── Step 3: Speed gate (optional) ─────────────────────────────────────
    if (
      config.maxSpeedMps != null &&
      data.locationSample.speedMps != null &&
      data.locationSample.speedMps > (config.maxSpeedMps as number)
    ) {
      await sessionRef.update({
        "timing.lastPingAt": FieldValue.serverTimestamp(),
        "antiCheat.lastRejectReason": "moving_too_fast",
      });
      return {
        status: session.status as string,
        inside: false,
        distanceM: -1,
        progressPercent: progressPercent(session, config),
        timeRemainingSec,
        rejectReason: "moving_too_fast",
      };
    }

    // ── Step 4: Compute distance ──────────────────────────────────────────
    const distanceM = haversineM(
      data.locationSample.lat,
      data.locationSample.lng,
      session.target.lat as number,
      session.target.lng as number
    );

    // ── Step 5: Determine inside ──────────────────────────────────────────
    const inside = distanceM <= (config.radiusM as number);

    // ── Step 6: Update session ────────────────────────────────────────────
    // Only accepted (inside) pings count toward locking.
    const currentSampleCount = session.sampling.acceptedSampleCount as number;
    const newSampleCount = inside ? currentSampleCount + 1 : currentSampleCount;
    const updatePayload: Record<string, unknown> = {
      "timing.lastPingAt": FieldValue.serverTimestamp(),
    };
    if (inside) {
      updatePayload["sampling.acceptedSampleCount"] = newSampleCount;
      updatePayload["sampling.lastAccepted"] = {
        lat: data.locationSample.lat,
        lng: data.locationSample.lng,
        accuracyM: data.locationSample.accuracyM,
        speedMps: data.locationSample.speedMps ?? null,
        distanceM,
        clientTs: Timestamp.fromMillis(data.locationSample.clientTs),
        serverTs: FieldValue.serverTimestamp(),
      };
    }

    // ── Step 7: Locking logic ─────────────────────────────────────────────
    let newStatus = session.status as string;
    if (
      session.status === "LOCKING" &&
      inside &&
      newSampleCount >= (config.minAcceptedSamplesToLock as number)
    ) {
      newStatus = "IN_PROGRESS";
      updatePayload["status"] = "IN_PROGRESS";
      updatePayload["timing.lockedAt"] = FieldValue.serverTimestamp();
    }

    // ── Step 8: DWELL logic ───────────────────────────────────────────────
    // TODO: implement for DWELL mode — accumulate dwell.accumulatedSec,
    // track dwell.consecutiveOutsideSec and dwell.totalOutsideSec,
    // apply maxStalePingSec clamp, handle grace threshold failures.

    await sessionRef.update(updatePayload);

    // ── Step 9: Return progress ───────────────────────────────────────────
    // CHECKIN: progress is acceptedSampleCount / minAcceptedSamplesToLock (capped at 1.0).
    // Once IN_PROGRESS the client auto-calls /complete.
    return {
      status: newStatus,
      inside,
      distanceM,
      progressPercent: Math.min(
        newSampleCount / (config.minAcceptedSamplesToLock as number),
        1.0
      ),
      timeRemainingSec,
    };
  }
);
