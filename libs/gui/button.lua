local CLASS = require "libs.class"
local Clickable = require "libs.gui.clickable"

---@class Button
local Button = CLASS.class("Button")

function Button.new(root, click_area)
    return CLASS.new_instance(Button, root, click_area)
end

function Button:initialize(root, click_area)
    self.root = root
    self.clickable = Clickable.new(click_area or root)
    self.ignore_input = false
    self.input_on_pressed = false
    self.checked = false --for checkboxes
    --fixed pressed_now 2 times when multi touch enabled
    self.pressed_now_time = socket.gettime()
    self:refresh_view()
end

function Button:set_input_on_pressed(on_pressed)
    self.input_on_pressed = on_pressed
end

function Button:on_input(action_id, action)
    if (self.ignore_input) then return false end
    if not self.clickable:on_input(action_id, action) then return false end

    if self.input_on_pressed and self.clickable.pressed_now then
        if socket.gettime() - self.pressed_now_time < 0.01 then
            self.clickable:reset()
            return false
        end
        self.checked = not self.checked
        if self.input_listener then self.input_listener(self) end
        self.clickable:reset()
        self.pressed_now_time = socket.gettime()
    elseif not self.input_on_pressed and self.clickable.clicked then
        self.checked = not self.checked
        if self.input_listener then self.input_listener(self) end
    end

    self:refresh_view()
    return self.clickable.consumed
end

function Button:refresh_view()

end

function Button:set_ignore_input(ignore)
    if self.ignore_input ~= ignore then
        self.ignore_input = ignore
        self.clickable:reset()
        self:refresh_view()
    end
end

function Button:set_checked(checked)
    self.checked = checked
    if self.input_listener then self.input_listener(self) end
    self:refresh_view()
end

function Button:set_checked_visual(checked)
    self.checked = checked
    self:refresh_view()
end

function Button:set_input_listener(listener)
    self.input_listener = listener
end

function Button:set_enabled(enable)
    gui.set_enabled(self.root, enable)
    if not enable then
        self.clickable:reset()
    end
end

function Button:reset()
    self.clickable:reset()
    self:refresh_view()
end

function Button:is_enabled()
    return gui.is_enabled(self.root)
end

return Button
