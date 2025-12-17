local CLASS = require "libs.class"
local Button = require "libs.gui.button"

---@class Checkbox:Button
local Btn = CLASS.class("Checkbox", Button)

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
        done = gui.get_node(root_name .. "/done"),
        click_area = status and click_area or root
    }
    self.scale = gui.get_scale(self.vh.bg)
    self.scale_pressed = self.scale * 0.9
    Button.initialize(self, self.vh.root, self.vh.click_area)
end

function Btn:refresh_view()
    gui.set_enabled(self.vh.done, self.checked)
    gui.set_scale(self.vh.bg, self.clickable.pressed and self.scale_pressed or self.scale)
end

return Btn
