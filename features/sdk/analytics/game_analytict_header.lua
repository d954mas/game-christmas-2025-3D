---@meta

---@class GameAnalyticsErrorEvent
---@field severity string One of "debug","info","warning","error","critical"
---@field message string

---@class GameAnalyticsDesignEvent
---@field eventId string
---@field value number|nil

---@class GameAnalyticsSdk
gameanalytics = {}

---Enable or disable sending events to GameAnalytics.
---@param enabled boolean
function gameanalytics.setEnabledEventSubmission(enabled) end

---Enable or disable info logging.
---@param enabled boolean
function gameanalytics.setEnabledInfoLog(enabled) end

---Set the first custom dimension (01) value.
---@param dimension string
function gameanalytics.setCustomDimension01(dimension) end

---Send an error event.
---@param event GameAnalyticsErrorEvent
function gameanalytics.addErrorEvent(event) end

---Send a design event (custom metric).
---@param event GameAnalyticsDesignEvent
function gameanalytics.addDesignEvent(event) end
