---@meta

---@alias PokiRewardedCallback fun(self:any, status:number)
---@alias PokiCommercialCallback fun(self:any)

---@class PokiSdkBridge
poki_sdk = {}

---Trigger a rewarded ad break.
---@param callback PokiRewardedCallback receives reward status constants
function poki_sdk.rewarded_break(callback) end

---Trigger a commercial ad break.
---@param callback PokiCommercialCallback called when the ad flow completes
function poki_sdk.commercial_break(callback) end

---Notify Poki the gameplay has resumed.
function poki_sdk.gameplay_start() end

---Notify Poki the gameplay has stopped (e.g. during ads).
function poki_sdk.gameplay_stop() end

---Report an error string to Poki analytics.
---@param message string
function poki_sdk.capture_error(message) end

---@type number
poki_sdk.REWARDED_BREAK_ERROR = 0
---@type number
poki_sdk.REWARDED_BREAK_START = 1
---@type number
poki_sdk.REWARDED_BREAK_SUCCESS = 2
