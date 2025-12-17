local CLASS = require "libs.class"
local Button = require "libs.gui.button"

local CHEKCKBOX_CHECKED = vmath.vector4(0.2824, 0.8, 0.0353, 1)     -- #48CC09")
local CHEKCKBOX_UNCHECKED = vmath.vector4(0.008, 0.1373, 0.2706, 1) -- #022345")
local TUMBLER_POS_CHECKED = vmath.vector3(16, 0, 0)
local TUMBLER_POS_UNCHECKED = vmath.vector3(-16, 0, 0)

---@class Tumbler:Button
local Btn = CLASS.class("Tumbler", Button)

function Btn.new(root_name)
	return CLASS.new_instance(Btn, root_name)
end

function Btn:initialize(root_name)
	self.root_name = root_name
	local status, click_area = pcall(gui.get_node, root_name .. "/click_area")
	local root = gui.get_node(root_name .. "/root")

	self.vh = {
		root = root,
		bg = gui.get_node(root_name .. "/bg"),
		pie = gui.get_node(root_name .. "/pie"),
		click_area = status and click_area or root
	}
	self.scale = gui.get_scale(self.vh.bg)
	self.scale_pressed = self.scale * 0.9
	Button.initialize(self, self.vh.root, self.vh.click_area)
end

function Btn:refresh_view()
	if self.checked then
		gui.set_color(self.vh.bg, CHEKCKBOX_CHECKED)
		gui.set_position(self.vh.pie, TUMBLER_POS_CHECKED)
	else
		gui.set_color(self.vh.bg, CHEKCKBOX_UNCHECKED)
		gui.set_position(self.vh.pie, TUMBLER_POS_UNCHECKED)
	end
	gui.set_scale(self.vh.bg, self.clickable.pressed and self.scale_pressed or self.scale)
end

return Btn
