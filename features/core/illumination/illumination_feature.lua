local IlluminationStoragePart = require "features.core.illumination.illumination_storage_part"

---@class IlluminationFeature:Feature
local IlluminationFeature = {}

function IlluminationFeature:on_storage_init(storage)
	self.storage = IlluminationStoragePart.new(storage)
end

---@param gui_script DebugGuiScript
function IlluminationFeature:on_debug_gui_added(gui_script)
	gui_script:add_game_checkbox("Illumination Shadow Debug", self.storage:is_debug_shadow(), function (checkbox)
		self.storage:set_debug_shadow(checkbox.checked)
	end)
	gui_script:add_game_checkbox("Illumination Lights Debug", self.storage:is_debug_lights(), function (checkbox)
		self.storage:set_debug_lights(checkbox.checked)
	end)
end

return IlluminationFeature
