local CLASS = require "libs.class"
local Button = require "libs.gui.button"

local GUI_SET_SCALE = gui.set_scale

---@class BtnScale:Button
local Btn = CLASS.class("ButtonScale", Button)

function Btn.new_from_node(root)
	return CLASS.new_instance(Btn, root)
end

function Btn.new(template_name)
	return CLASS.new_instance(Btn, gui.get_node(template_name .. "/root"))
end

function Btn:set_position(position)
	gui.set_position(self.root, position)
end

function Btn:initialize(root)
	self.scale = {
		init = gui.get_scale(root)
	}
	self.scale.pressed = self.scale.init * 0.9
	self.scale.current = self.scale.init
	Button.initialize(self, root)
end

function Btn:refresh_view()
	if self.clickable.pressed then
		self.scale.current = self.scale.pressed
		GUI_SET_SCALE(self.root, self.scale.current)
	else
		self.scale.current = self.scale.init
		GUI_SET_SCALE(self.root, self.scale.current)
	end
end

function Btn:on_input(action_id, action)
	--fixed root pick node for scaled node
	GUI_SET_SCALE(self.root, self.scale.init)
	local consumed = Button.on_input(self, action_id, action)
	GUI_SET_SCALE(self.root, self.scale.current)
	return consumed
end

return Btn
