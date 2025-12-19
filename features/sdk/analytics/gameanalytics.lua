local CONSTANTS = require "libs.constants"
local GA = {}

function GA:init()
    assert(not self.is_initialized)
	if not gameanalytics then return end
	self.is_initialized = true
	local enableEventSubmission = true
    --Can disable event submission for testing purposes
	if (CONSTANTS.PLATFORM_IS_PC) then
		enableEventSubmission = false
	end
	gameanalytics.setEnabledEventSubmission(enableEventSubmission)
	gameanalytics.setEnabledInfoLog(CONSTANTS.VERSION_IS_DEV)
	gameanalytics.setCustomDimension01(CONSTANTS.GAME_TARGET)
end

---@param message string
function GA:error(message)
	if gameanalytics then gameanalytics.addErrorEvent({ severity = "Error", message = message }) end
end

---@param id string
---@param value any
function GA:event(id, value)
	if gameanalytics then gameanalytics.addDesignEvent({ eventId = id, value = value }) end
end


return GA
