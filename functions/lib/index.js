"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateComplete = exports.validatePing = exports.validateStart = void 0;
const app_1 = require("firebase-admin/app");
(0, app_1.initializeApp)();
var start_1 = require("./validate/start");
Object.defineProperty(exports, "validateStart", { enumerable: true, get: function () { return start_1.validateStart; } });
var ping_1 = require("./validate/ping");
Object.defineProperty(exports, "validatePing", { enumerable: true, get: function () { return ping_1.validatePing; } });
var complete_1 = require("./validate/complete");
Object.defineProperty(exports, "validateComplete", { enumerable: true, get: function () { return complete_1.validateComplete; } });
//# sourceMappingURL=index.js.map