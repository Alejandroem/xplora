import { initializeApp } from "firebase-admin/app";
initializeApp();

export { validateStart } from "./validate/start";
export { validatePing } from "./validate/ping";
export { validateComplete } from "./validate/complete";
