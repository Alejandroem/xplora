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
}
