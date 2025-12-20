local CLASS = require "libs.class"
local INPUT = require "features.core.input.input"
local LUME = require "libs.lume"
local GUI_RESIZER = require "features.core.gui_resizer"

local VirtualPad = CLASS.class("VirtualPad")

function VirtualPad.new(root_name, borders) return CLASS.new_instance(VirtualPad, root_name, borders) end

function VirtualPad:initialize(root_name, borders)
    self.root_name = assert(root_name)
    self.always_visible = true
    self.always_visible_before_first_input = true
    self:bind_vh()
    self:init_view()
    self.enabled = true
    self.touch_id = nil
    self.safe_zone_time = 100
    self.borders = borders or { 0, 0, RENDER.screen_size.w, RENDER.screen_size.h } --x,y,x2,y2
    self.borders_2 = borders or { 0, 0, RENDER.screen_size.w, RENDER.screen_size.h } --x,y,x2,y2
    self.blocked_touch_idx = nil
    self.fixed_position = true
    self.scale_base = gui.get_scale(self.vh.anchor)
    self.scale = vmath.vector3(self.scale_base)
    self.position_initial = gui.get_position(self.vh.anchor)
    self:on_resize()
end

function VirtualPad:set_enabled(enabled)
    self.enabled = enabled
end

function VirtualPad:is_enabled()
    return self.enabled
end

function VirtualPad:set_blocked_touch(touch_id)
    self.blocked_touch_idx = touch_id
end

function VirtualPad:bind_vh()
    self.vh = {
        click_area = gui.get_node(self.root_name .. "/click_area"),
        anchor = gui.get_node(self.root_name .. "/anchor"),
        root = gui.get_node(self.root_name .. "/root"),
        bg = gui.get_node(self.root_name .. "/bg"),
        center = gui.get_node(self.root_name .. "/center"),
        drag = gui.get_node(self.root_name .. "/drag"),
        left_bottom = gui.get_node(self.root_name .. "/left_bottom"),
        left_bottom_all = gui.get_node(self.root_name .. "/left_bottom_all"),
        right_top = gui.get_node(self.root_name .. "/right_top"),
        right_top_all = gui.get_node(self.root_name .. "/right_top_all"),
    }
end

function VirtualPad:init_view()
    self.data = {
        position = vmath.vector3(0),
        position_drag = vmath.vector3(0),
        dist_max = 100,
        dist_safe = 10,
    }
    if not self.always_visible and not self.always_visible_before_first_input then
        self:visible_set(false)
    end
end

function VirtualPad:visible_set(visible)
    gui.set_enabled(self.vh.root, visible)
end

function VirtualPad:visible_is()
    return gui.is_enabled(self.vh.root)
end

function VirtualPad:screen_to_drag(x, y)
    local local_x = x - self.position_screen_left_bottom.x
    local local_y = y - self.position_screen_left_bottom.y
    local screen_w = self.position_screen_right_top.x - self.position_screen_left_bottom.x
    local screen_h = self.position_screen_right_top.y - self.position_screen_left_bottom.y
    return (-1 + (local_x / screen_w) * 2) * self.data.dist_max, (-1 + (local_y / screen_h) * 2) * self.data.dist_max
end

function VirtualPad:pressed(screen_x, screen_y, touch_id)
    self.touch_id = touch_id or 0
    if self.fixed_position then
        self.data.position.x, self.data.position.y = self.position_screen_root.x, self.position_screen_root.y
        self:visible_set(true)
        self.data.position_drag.x, self.data.position_drag.y = self:screen_to_drag(screen_x, screen_y)
    else
        local coordinates = gui.screen_to_local(self.vh.anchor, vmath.vector3(screen_x, screen_y, 0))
        gui.set_position(self.vh.anchor, coordinates)
        self:on_resize()

        --move center of pad to be center. Prev was anchor
        local w = self.position_screen_right_top_all.x - self.position_screen_left_bottom_all.x
        local h = self.position_screen_right_top_all.y - self.position_screen_left_bottom_all.y
        coordinates = gui.screen_to_local(self.vh.anchor, vmath.vector3(screen_x - w / 2, screen_y - h / 2, 0))
        gui.set_position(self.vh.anchor, coordinates)
        self:on_resize()

        self.data.position.x, self.data.position.y = self.position_screen_root.x, self.position_screen_root.y
        self:visible_set(true)
        self.data.position_drag.x, self.data.position_drag.y = 0, 0
    end
end

function VirtualPad:is_in_borders(screen_x, screen_y)
    local in_area = screen_x <= self.borders[3] and screen_x >= self.borders[1] and screen_y <= self.borders[4] and
    screen_y >= self.borders[2]
    if in_area then return true end
    in_area = screen_x <= self.borders_2[3] and screen_x >= self.borders_2[1] and screen_y <= self.borders_2[4] and
    screen_y >= self.borders_2[2]
    if in_area then return true end
    return false
end

function VirtualPad:reset()
    self.data.position.x, self.data.position.y = 0, 0
    self.data.position_drag.x, self.data.position_drag.y = 0, 0
    gui.set_position(self.vh.drag, self.data.position_drag)
    if not self.always_visible and not self.always_visible_before_first_input then
        self:visible_set(false)
    end
    self.touch_id = nil
    self.safe_zone_time = 100
    gui.set_position(self.vh.anchor, self.position_initial)
end

local ACTIONS = {}
function VirtualPad:on_input()
    if (not self.enabled) then return false end
    LUME.cleari(ACTIONS)
    if INPUT.TOUCH then
        INPUT.TOUCH.id = 0
        ACTIONS[1] = INPUT.TOUCH
    end
    if INPUT.TOUCH_MULTI then
        for _, action in ipairs(INPUT.TOUCH_MULTI) do
            table.insert(ACTIONS, action)
        end
    end

    local handled_action = false
    --check current finger
    for _, action in ipairs(ACTIONS) do
        if (action.id == self.touch_id) then
            --handled_action = action.screen_x <= self.borders[3] and action
            handled_action = action -- do not reset when move
            break
        end
    end
    if (not handled_action) then
        --try find new finger
        for _, action in ipairs(ACTIONS) do
            local x, y = action.x, action.y
            if action.id ~= self.blocked_touch_idx then
                if not self.fixed_position then
                    if (self:is_in_borders(action.screen_x, action.screen_y)) then
                        self.first_input = true
                        if self.always_visible_before_first_input then
                            self.always_visible_before_first_input = false
                        end
                        self:pressed(action.screen_x, action.screen_y, action.id)
                        handled_action = action
                        break
                    end
                else
                    if gui.pick_node(self.vh.click_area, x, y) then
                        self:pressed(action.screen_x, action.screen_y, action.id)
                        handled_action = action
                        break
                    end
                end
            end
        end
    end
    if (not handled_action) then
        self:reset()
        return
    end



    local drag_x, drag_y = self:screen_to_drag(handled_action.screen_x, handled_action.screen_y)
    if (self:visible_is()) then
        self.data.position_drag.x = drag_x
        self.data.position_drag.y = drag_y
        local dist = vmath.length(self.data.position_drag)
        if (dist > self.data.dist_max) then
            local scale = self.data.dist_max / dist
            self.data.position_drag.x = self.data.position_drag.x * scale
            self.data.position_drag.y = self.data.position_drag.y * scale
        end
        gui.set_position(self.vh.drag, self.data.position_drag)
    end
    if (handled_action.released) then
        self:reset()
    end
end

---@return number x[-1,1]
---@return number y[-1,1]
function VirtualPad:get_data()
    local x = LUME.clamp(self.data.position_drag.x / self.data.dist_max, -1, 1)
    local y = LUME.clamp(self.data.position_drag.y / self.data.dist_max, -1, 1)
    return x, y
end

function VirtualPad:is_in_safe_area()
    local dist = vmath.length(self.data.position_drag)
    return dist < self.data.dist_safe
end

function VirtualPad:is_safe()
    if (self.safe_zone_time < 0.33) then
        return false
    end
    return self:is_in_safe_area()
end

function VirtualPad:update(dt)
    if (self:visible_is()) then
        if INPUT.IGNORE or (not self.always_visible_before_first_input and not self.touch_id) then
            self:reset()
        end
        if (self:is_in_safe_area()) then
            self.safe_zone_time = self.safe_zone_time + dt
        else
            self.safe_zone_time = 0
        end
    end
end

function VirtualPad:set_borders(x, y, x2, y2)
    self.borders[1] = x
    self.borders[2] = y
    self.borders[3] = x2
    self.borders[4] = y2
end
function VirtualPad:set_borders_2(x, y, x2, y2)
    self.borders_2[1] = x
    self.borders_2[2] = y
    self.borders_2[3] = x2
    self.borders_2[4] = y2
end

function VirtualPad:on_resize()
    xmath.vector(self.scale, self.scale_base)
    local aspect_base = RENDER.config_size.aspect
    if RENDER.screen_size.aspect >= aspect_base then
        gui.set_adjust_mode(self.vh.root, gui.ADJUST_FIT)
    else
        gui.set_adjust_mode(self.vh.root, gui.ADJUST_ZOOM)
        local scale_mul = GUI_RESIZER.get_scale(2).scale
        xmath.mul_per_elem(self.scale, self.scale, scale_mul)
    end
    gui.set_scale(self.vh.anchor, self.scale)
    self.position_screen_left_bottom = gui.get_screen_position(self.vh.left_bottom)
    self.position_screen_right_top = gui.get_screen_position(self.vh.right_top)
    self.position_screen_left_bottom_all = gui.get_screen_position(self.vh.left_bottom_all)
    self.position_screen_right_top_all = gui.get_screen_position(self.vh.right_top_all)
    self.position_screen_root = gui.get_screen_position(self.vh.root)
end

return VirtualPad
