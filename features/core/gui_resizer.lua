local CLASS = require "libs.class"
local CHECKS = require "libs.checks"
local SAFEAREA = require "features.core.safearea.safearea_feature"

local TEMP_V = vmath.vector3()

local CONFIG_SAFE_AREA = {
	top = "?number",
	bottom = "?number",
	left = "?number",
	right = "?number",
}

local GUI_SCALE = {
	mode = gui.ADJUST_FIT,
	scales = {
		{ scale = vmath.vector3(1), aspect = 10 / 16 }, --biggest
		{ scale = vmath.vector3(1), aspect = (3 / 4) },--default
		{ scale = vmath.vector3(1), aspect = (3.5 / 4) },
		{ scale = vmath.vector3(1), aspect = (4 / 4) }, --smallest
	}
}

---@class GuiResizer
local GuiResizer = CLASS.class("GuiResizer")

function GuiResizer.new() return CLASS.new_instance(GuiResizer) end

function GuiResizer:initialize()
	self.nodes = {}
end

function GuiResizer:add_node(node, scale_idx, safe_area_config)
	CHECKS("?", "userdata", "?number", CONFIG_SAFE_AREA)
	table.insert(self.nodes, { node = node, scale_idx = scale_idx or 2, safe_area_config = safe_area_config, position = gui.get_position(node) })
end

function GuiResizer:resize()
	local mode = GUI_SCALE.mode
	for i = 1, #self.nodes do
		local data = self.nodes[i]
		local node = data.node
		gui.set_scale(node, GUI_SCALE.scales[data.scale_idx].scale)
		gui.set_adjust_mode(node, mode)
		local safe_config = data.safe_area_config
		if safe_config and (safe_config.top or safe_config.left or safe_config.right or safe_config.bottom) then
			xmath.vector(TEMP_V, data.position)
			if safe_config.left then TEMP_V.x = TEMP_V.x + SAFEAREA.safearea_gui.left end
			if safe_config.right then TEMP_V.x = TEMP_V.x - SAFEAREA.safearea_gui.right end
			if safe_config.top then TEMP_V.y = TEMP_V.y - SAFEAREA.safearea_gui.top end
			if safe_config.bottom then TEMP_V.y = TEMP_V.y + SAFEAREA.safearea_gui.bottom end
			gui.set_position(node, TEMP_V)
		end
	end
end

function GuiResizer.update_screen_size(screen_size, config_size)
	for i = 1, #GUI_SCALE.scales do
		local scale_data = GUI_SCALE.scales[i]
		if screen_size.aspect < scale_data.aspect then
			local scale_target = config_size.aspect / scale_data.aspect
			local scale_current = config_size.aspect / (screen_size.aspect)
			local gui_scale = scale_target / scale_current
			scale_data.scale.x, scale_data.scale.y, scale_data.scale.z = gui_scale, gui_scale, gui_scale
		else
			scale_data.scale.x, scale_data.scale.y, scale_data.scale.z = 1, 1, 1
		end
	end

	GUI_SCALE.mode = screen_size.aspect >= config_size.aspect and gui.ADJUST_FIT or gui.ADJUST_ZOOM
end

function GuiResizer.get_scale(idx)
	return GUI_SCALE.scales[idx]
end

function GuiResizer.get_mode()
	return GUI_SCALE.mode
end

return GuiResizer
