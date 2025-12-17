local CLASS = require "libs.class"
local Clickable = require "libs.gui.clickable"
local LUME = require "libs.lume"

local TEMP_V = vmath.vector3()
local TEMP_V4 = vmath.vector4()

---@class Slider
local Slider = CLASS.class("Slider")

function Slider.new_from_nodes(root, slider, area)
    return CLASS.new_instance(Slider, root, slider, area)
end

function Slider.new(template_name)
    local root = gui.get_node(template_name .. "/root")
    local slider = gui.get_node(template_name .. "/slider")
    local area = gui.get_node(template_name .. "/area")
    return CLASS.new_instance(Slider, root, slider, area)
end

function Slider.new_fg(template_name)
    local root = gui.get_node(template_name .. "/root")
    local slider = gui.get_node(template_name .. "/slider")
    local area = gui.get_node(template_name .. "/area")
    local fg = gui.get_node(template_name .. "/fg")
    return CLASS.new_instance(Slider, root, slider, area, fg)
end

function Slider:initialize(root, slider_node, area_node, fg_node)
    self.root = root
    self.vh = {
        root = root,
        slider = slider_node,
        area = area_node,
        fg = fg_node
    }
    self.clickable = Clickable.new(root)
    self.ignore_input = false

    self.value = 0
    self.value_max = 1

    local area = gui.get_size(self.vh.area)
    self.area = { p1 = -area.x / 2, p2 = area.x / 2, size = area.x }
    self.slider_position = gui.get_position(self.vh.slider)



    --using screen_to_local is input return wrong value
    --so now i use 2 new nodes at end area and start
    self.node_area_start = gui.new_box_node(vmath.vector3(-area.x / 2, 0, 0), vmath.vector3(1, 1, 1))
    gui.set_enabled(self.node_area_start, false)
    gui.set_parent(self.node_area_start, self.vh.area)

    self.node_area_end = gui.new_box_node(vmath.vector3(area.x / 2, 0, 0), vmath.vector3(1, 1, 1))
    gui.set_enabled(self.node_area_end, false)
    gui.set_parent(self.node_area_end, self.vh.area)

    if self.vh.fg then
        self.fg_size = gui.get_size(self.vh.fg)
        self.fg_slice9 = gui.get_slice9(self.vh.fg)
    end

    self:refresh_view()
end

function Slider:set_value(value)
    self.value = math.min(value, self.value_max)
    self:refresh_view()
end

function Slider:set_value_max(value_max)
    self.value_max = value_max
    self:refresh_view()
end

function Slider:on_input(action_id, action)
    if (self.ignore_input) then return false end
    if not self.clickable:on_input(action_id, action) then return false end

    if self.clickable.pressed then
        local p1 = gui.get_screen_position(self.node_area_start)
        local p2 = gui.get_screen_position(self.node_area_end)

        local value_new = LUME.clamp((action.screen_x - p1.x) / (p2.x - p1.x), 0, 1) * self.value_max
        if value_new ~= self.value then
            self.value = value_new
            self:refresh_view()
            if self.change_listener then self.change_listener(self) end
        end
    end

    self:refresh_view()
    return self.clickable.consumed
end

function Slider:refresh_view()
    local x = self.area.p1 + (self.value / self.value_max) * self.area.size
    self.slider_position.x = x
    gui.set_position(self.vh.slider, self.slider_position)
    if self.vh.fg then
        TEMP_V.x = self.fg_size.x * self.value / self.value_max
        TEMP_V.y = self.fg_size.y
        TEMP_V.z = self.fg_size.z
        gui.set_size(self.vh.fg, TEMP_V)
        local w = self.fg_slice9.x + self.fg_slice9.z
        local scale = TEMP_V.x < w and TEMP_V.x/w or 1
        TEMP_V4.x = math.floor(self.fg_slice9.x * scale)
        TEMP_V4.y = self.fg_slice9.y
        TEMP_V4.z = math.floor(self.fg_slice9.z * scale)
        TEMP_V4.w = self.fg_slice9.w
        gui.set_slice9(self.vh.fg, TEMP_V4)
    end
end

function Slider:set_ignore_input(ignore)
    self.ignore_input = ignore
    self.clickable:reset()
    self:refresh_view()
end

function Slider:set_change_listener(listener)
    self.change_listener = listener
end

function Slider:set_enabled(enable)
    gui.set_enabled(self.root, enable)
end

function Slider:is_enabled()
    return gui.is_enabled(self.root)
end

return Slider
