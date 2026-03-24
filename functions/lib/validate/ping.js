"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validatePing = void 0;
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-admin/firestore");
// Haversine — returns distance in metres between two lat/lng points
function haversineM(lat1, lng1, lat2, lng2) {
    const R = 6371000;
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLng = ((lng2 - lng1) * Math.PI) / 180;
    const a = Math.sin(dLat / 2) ** 2 +
        Math.cos((lat1 * Math.PI) / 180) *
            Math.cos((lat2 * Math.PI) / 180) *
            Math.sin(dLng / 2) ** 2;
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}
function progressPercent(session, config) {
    return Math.min(session.sampling.acceptedSampleCount /
        config.minAcceptedSamplesToLock, 1.0);
}
exports.validatePing = (0, https_1.onCall)({ invoker: "public" }, async (request) => {
    var _a;
    const db = (0, firestore_1.getFirestore)();
    // ── Step 1: Auth ──────────────────────────────────────────────────────
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "Authentication required.");
    }
    const uid = request.auth.uid;
    const data = request.data;
    // ── Step 1 cont: Load session ─────────────────────────────────────────
    const sessionRef = db.doc(`users/${uid}/validationSessions/${data.sessionId}`);
    const sessionSnap = await sessionRef.get();
    if (!sessionSnap.exists) {
        throw new https_1.HttpsError("not-found", "Session not found.");
    }
    const session = sessionSnap.data();
    const config = session.configSnapshot;
    // Verify not expired
    const expiresAt = session.timing.expiresAt.toDate();
    if (expiresAt <= new Date()) {
        await sessionRef.update({ status: "EXPIRED" });
        throw new https_1.HttpsError("failed-precondition", "Session expired.");
    }
    // Verify not already terminal
    const terminalStatuses = ["COMPLETED", "EXPIRED", "FAILED"];
    if (terminalStatuses.includes(session.status)) {
        throw new https_1.HttpsError("failed-precondition", `Session already ${session.status.toLowerCase()}.`);
    }
    const timeRemainingSec = Math.max(0, Math.floor((expiresAt.getTime() - Date.now()) / 1000));
    // ── Step 2: Accuracy gate ─────────────────────────────────────────────
    if (data.locationSample.accuracyM > config.minAccuracyM) {
        await sessionRef.update({
            "timing.lastPingAt": firestore_1.FieldValue.serverTimestamp(),
            "antiCheat.lastRejectReason": "accuracy_too_low",
        });
        return {
            status: session.status,
            inside: false,
            distanceM: -1,
            progressPercent: progressPercent(session, config),
            timeRemainingSec,
            rejectReason: "accuracy_too_low",
        };
    }
    // ── Step 3: Speed gate (optional) ─────────────────────────────────────
    if (config.maxSpeedMps != null &&
        data.locationSample.speedMps != null &&
        data.locationSample.speedMps > config.maxSpeedMps) {
        await sessionRef.update({
            "timing.lastPingAt": firestore_1.FieldValue.serverTimestamp(),
            "antiCheat.lastRejectReason": "moving_too_fast",
        });
        return {
            status: session.status,
            inside: false,
            distanceM: -1,
            progressPercent: progressPercent(session, config),
            timeRemainingSec,
            rejectReason: "moving_too_fast",
        };
    }
    // ── Step 4: Compute distance ──────────────────────────────────────────
    const distanceM = haversineM(data.locationSample.lat, data.locationSample.lng, session.target.lat, session.target.lng);
    // ── Step 5: Determine inside ──────────────────────────────────────────
    const inside = distanceM <= config.radiusM;
    // ── Step 6: Update session ────────────────────────────────────────────
    // Only accepted (inside) pings count toward locking.
    const currentSampleCount = session.sampling.acceptedSampleCount;
    const newSampleCount = inside ? currentSampleCount + 1 : currentSampleCount;
    const updatePayload = {
        "timing.lastPingAt": firestore_1.FieldValue.serverTimestamp(),
    };
    if (inside) {
        updatePayload["sampling.acceptedSampleCount"] = newSampleCount;
        updatePayload["sampling.lastAccepted"] = {
            lat: data.locationSample.lat,
            lng: data.locationSample.lng,
            accuracyM: data.locationSample.accuracyM,
            speedMps: (_a = data.locationSample.speedMps) !== null && _a !== void 0 ? _a : null,
            distanceM,
            clientTs: firestore_1.Timestamp.fromMillis(data.locationSample.clientTs),
            serverTs: firestore_1.FieldValue.serverTimestamp(),
        };
    }
    // ── Step 7: Locking logic ─────────────────────────────────────────────
    let newStatus = session.status;
    if (session.status === "LOCKING" &&
        inside &&
        newSampleCount >= config.minAcceptedSamplesToLock) {
        newStatus = "IN_PROGRESS";
        updatePayload["status"] = "IN_PROGRESS";
        updatePayload["timing.lockedAt"] = firestore_1.FieldValue.serverTimestamp();
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
        progressPercent: Math.min(newSampleCount / config.minAcceptedSamplesToLock, 1.0),
        timeRemainingSec,
    };
});
//# sourceMappingURL=ping.js.map