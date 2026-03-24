export interface LocationSample {
  lat: number;
  lng: number;
  accuracyM: number;
  speedMps: number | null;
  clientTs: number; // Unix ms — stored for audit only, never trusted for logic
  isMocked: boolean;
}

export interface StartRequest {
  scopeType: "PLACE" | "QUEST" | "EVENT";
  scopeId: string;
  mode: "CHECKIN" | "DWELL";
  locationSample: LocationSample;
  deviceInfo?: {
    deviceIdHash: string;
  };
}

export interface StartResponse {
  sessionId: string;
  status: string;
  target: {
    lat: number;
    lng: number;
    radiusM: number;
  };
  requiresQrOrCode: boolean;
  expiresAt: number; // Unix ms
  pingRecommendedIntervalSec: number;
}

export interface PingRequest {
  sessionId: string;
  locationSample: Omit<LocationSample, "isMocked">;
  appState: "FOREGROUND" | "BACKGROUND";
}

export interface PingResponse {
  status: string;
  inside: boolean;
  distanceM: number;
  progressPercent: number; // 0..1
  timeRemainingSec: number;
  rejectReason?: string;
}

export interface CompleteRequest {
  sessionId: string;
  // TODO: qrTokenId?: string; — skip until QR is implemented
  // TODO: code?: string;      — skip until code is implemented
  finalLocationSample?: Omit<LocationSample, "isMocked">;
}

export interface CompleteResponse {
  success: boolean;
  completedAt: number;          // Unix ms
  timesCompleted: number;
  cooldownUntil: number | null; // Unix ms, null if no cooldown
  // TODO: rewards payload
}
