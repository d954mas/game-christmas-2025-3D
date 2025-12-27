local DebugDefoldPhysicsStoragePart = require "features.debug.debug_defold_physics_storage_part"

---@class DebugDefoldPhysicsFeature:Feature
local Feature = {}

---@param storage Storage
function Feature:on_storage_init(storage)
	self.storage = DebugDefoldPhysicsStoragePart.new(storage)
end

---@param gui_script DebugGuiScript
function Feature:on_debug_gui_added(gui_script)
	gui_script:add_game_checkbox("Physics Debug", self.storage:draw_physics_is(), function (checkbox)
		self.storage:draw_physics_set(checkbox.checked)
		msg.post("@system:", "toggle_physics_debug")
	end)

	--reset toggle_physics_debug after added checkbox
	if not self.storage:draw_physics_is() then
		msg.post("@system:", "toggle_physics_debug")
	end
end

return Feature
