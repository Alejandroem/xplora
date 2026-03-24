"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateStart = void 0;
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-admin/firestore");
exports.validateStart = (0, https_1.onCall)({ invoker: "public" }, async (request) => {
    var _a, _b;
    const db = (0, firestore_1.getFirestore)();
    // ── Step 1: Auth ──────────────────────────────────────────────────────
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "Authentication required.");
    }
    const uid = request.auth.uid;
    const data = request.data;
    // ── Step 2: Load entity ───────────────────────────────────────────────
    // Currently only PLACE is supported.
    // TODO: QUEST → load quests/{scopeId} then its associated place if needed
    // TODO: EVENT → load events/{scopeId} and its place/geo override
    if (data.scopeType !== "PLACE") {
        throw new https_1.HttpsError("unimplemented", `scopeType "${data.scopeType}" is not yet supported.`);
    }
    const placeSnap = await db.doc(`places/${data.scopeId}`).get();
    if (!placeSnap.exists) {
        throw new https_1.HttpsError("not-found", "Place not found.");
    }
    const place = placeSnap.data();
    // ── Step 3: Determine targetGeo ───────────────────────────────────────
    // PLACE: geo.geopoint field
    // EVENT: geoOverride if present, else place geo (not implemented yet)
    const geopoint = (_a = place.geo) === null || _a === void 0 ? void 0 : _a.geopoint;
    if (!geopoint) {
        throw new https_1.HttpsError("failed-precondition", "Place has no geo data.");
    }
    const targetGeo = {
        lat: geopoint.latitude,
        lng: geopoint.longitude,
    };
    // ── Step 4: Load config ───────────────────────────────────────────────
    // Priority: place.validationConfig (embedded) → globalDefault doc
    // TODO: for QUEST/EVENT, check entity.validationConfig first
    let config;
    if (place.validationConfig) {
        config = place.validationConfig;
    }
    else {
        // Fallback to the globalDefault doc
        const globalSnap = await db
            .doc("validationConfigs/globalDefault")
            .get();
        if (!globalSnap.exists) {
            throw new https_1.HttpsError("failed-precondition", "No validation config available for this place.");
        }
        config = Object.assign({ id: globalSnap.id }, globalSnap.data());
    }
    // ── Step 5: Enforce availability ──────────────────────────────────────
    // PLACE: status must be "active"
    // TODO: EVENT — check schedule window and [startTime, endTime] with grace
    if (place.status !== "active") {
        throw new https_1.HttpsError("failed-precondition", "Place is not active.");
    }
    // Speed check (server-side enforcement using the submitted locationSample)
    if (config.maxSpeedMps != null &&
        data.locationSample.speedMps != null &&
        data.locationSample.speedMps > config.maxSpeedMps) {
        throw new https_1.HttpsError("failed-precondition", "Moving too fast for check-in.");
    }
    // Mock location check
    if (config.denyIfMockLocationSuspected && data.locationSample.isMocked) {
        throw new https_1.HttpsError("failed-precondition", "Mock location detected.");
    }
    // ── Step 6: Enforce completion constraints ────────────────────────────
    // Completion doc: users/{uid}/completions/PLACE_{scopeId}
    const completionRef = db.doc(`users/${uid}/completions/PLACE_${data.scopeId}`);
    const completionSnap = await completionRef.get();
    if (completionSnap.exists) {
        const completion = completionSnap.data();
        // oneTimeOnly: deny if already consumed
        if (config.oneTimeOnly && completion.oneTimeConsumed === true) {
            throw new https_1.HttpsError("failed-precondition", "This check-in can only be completed once.");
        }
        // cooldown: deny if cooldownUntil is still in the future
        if (completion.cooldownUntil) {
            const cooldownUntil = completion.cooldownUntil.toDate();
            if (cooldownUntil > new Date()) {
                throw new https_1.HttpsError("failed-precondition", "Check-in is on cooldown.");
            }
        }
    }
    // ── Steps 7 & 8: Transaction — session limit check + session creation ─
    // Both run in a single transaction to prevent race conditions from
    // simultaneous /start calls by the same user.
    const sessionsRef = db.collection(`users/${uid}/validationSessions`);
    const newSessionRef = sessionsRef.doc(); // pre-generate ID before tx
    const expiresAtMs = Date.now() + config.sessionTtlSec * 1000;
    const expiresAt = firestore_1.Timestamp.fromMillis(expiresAtMs);
    await db.runTransaction(async (tx) => {
        var _a, _b;
        // Step 7: Count active sessions for this user.
        // Filter by expiresAt > now so logically expired sessions (not yet
        // marked EXPIRED by the scheduler) don't block new ones.
        const activeQuery = await tx.get(sessionsRef
            .where("status", "in", [
            "CREATED",
            "LOCKING",
            "IN_PROGRESS",
            "READY_TO_COMPLETE",
        ])
            .where("timing.expiresAt", ">", firestore_1.Timestamp.now()));
        if (activeQuery.size >= config.maxActiveSessionsPerUser) {
            throw new https_1.HttpsError("resource-exhausted", "Maximum active check-in sessions reached.");
        }
        // Step 8: Create session doc with status LOCKING
        tx.set(newSessionRef, Object.assign(Object.assign({ uid, scope: {
                scopeType: data.scopeType,
                placeId: data.scopeId,
            }, mode: data.mode, status: "LOCKING", 
            // Full config snapshot — server uses this for all subsequent validation.
            // Decouples session from live config changes mid-session.
            configSnapshot: config, target: {
                lat: targetGeo.lat,
                lng: targetGeo.lng,
                radiusM: config.radiusM,
            }, timing: {
                createdAt: firestore_1.FieldValue.serverTimestamp(),
                expiresAt,
                lockedAt: null,
                lastPingAt: null,
                completedAt: null,
            }, sampling: {
                acceptedSampleCount: 0,
                lastAccepted: null,
            } }, (data.mode === "DWELL" && {
            dwell: {
                requiredSec: 0,
                accumulatedSec: 0,
                totalOutsideSec: 0,
                consecutiveOutsideSec: 0,
            },
        })), { antiCheat: {
                codeAttempts: 0,
                codeAttemptWindowStartAt: null,
                lastRejectReason: null,
                deviceIdHash: (_b = (_a = data.deviceInfo) === null || _a === void 0 ? void 0 : _a.deviceIdHash) !== null && _b !== void 0 ? _b : null,
            }, 
            // Initial location sample stored for audit — clientTs is never trusted
            initialSample: {
                lat: data.locationSample.lat,
                lng: data.locationSample.lng,
                accuracyM: data.locationSample.accuracyM,
                speedMps: data.locationSample.speedMps,
                clientTs: firestore_1.Timestamp.fromMillis(data.locationSample.clientTs),
                isMocked: data.locationSample.isMocked,
            }, result: {
                rewardTxnId: null,
                completionReason: null,
            } }));
    });
    // ── Step 9: Return ────────────────────────────────────────────────────
    return {
        sessionId: newSessionRef.id,
        status: "LOCKING",
        target: {
            lat: targetGeo.lat,
            lng: targetGeo.lng,
            radiusM: config.radiusM,
        },
        requiresQrOrCode: (_b = config.requiresQrOrCode) !== null && _b !== void 0 ? _b : false,
        expiresAt: expiresAtMs,
        pingRecommendedIntervalSec: config.pingRecommendedIntervalSec,
    };
});
//# sourceMappingURL=start.js.map