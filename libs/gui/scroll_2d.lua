local CLASS = require "libs.class"
local HASHES = require "libs.hashes"
local LUME = require "libs.lume"
local INPUT = require "libs.input"
local Clickable = require "libs.gui.clickable"

local HASH_TOUCH = HASHES.INPUT.TOUCH
local HASH_TOUCH_MULTI = HASHES.INPUT.TOUCH_MULTI

---@class Scroll2D
local Scroll = CLASS.class("Scroll2D")

function Scroll.new(culling_node, content_node)
    return CLASS.new_instance(Scroll, culling_node, content_node)
end

function Scroll:reset()
    self.clickable:reset()
    self.have_scrolled = false
    self.scroll_speed = vmath.vector3(0)
    self.scroll_time = 0
end

function Scroll:initialize(culling_node, content_node)
    self.culling_node = culling_node
    self.content_node = content_node
    self.scroll_pos = vmath.vector3()
    self.scroll = vmath.vector3()
    self.culling_node_size = gui.get_size(self.culling_node)
    self.scroll_wheel = 15
    self.content_mode = "size"
    self.bounds = nil

    self.content_top_node = gui.new_box_node(vmath.vector3(0), vmath.vector3(1))
    self.content_bottom_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(1))
    gui.set_parent(self.content_top_node, content_node)
    gui.set_parent(self.content_bottom_node, content_node)

    self:set_content_size(gui.get_size(self.content_node))

    self.clickable = Clickable.new(self.culling_node)
    self:reset()
    self:on_resize()

    self.ignore_input = false
    self:refresh_view()
end

function Scroll:_set_scroll_from_position(pos_x, pos_y)
    local x = 0
    local y = 0

    local range_x = self.max_x - self.min_x
    if math.abs(range_x) > 0.0001 then
        x = (pos_x - self.min_x) / range_x
    end

    local range_y = self.max_y - self.min_y
    if math.abs(range_y) > 0.0001 then
        y = (pos_y - self.min_y) / range_y
    end

    self:scroll_to(x, y)
end

function Scroll:_update_scroll_area_nodes()
    local range_x = self.max_x - self.min_x
    local range_y = self.max_y - self.min_y
    gui.set_position(self.content_top_node, vmath.vector3(range_x, range_y, 0))
    gui.set_position(self.content_bottom_node, vmath.vector3(0, 0, 0))
end

function Scroll:_update_screen_size()
    self.content_top_node_screen_pos = gui.get_screen_position(self.content_top_node)
    self.content_bottom_node_screen_pos = gui.get_screen_position(self.content_bottom_node)
    self.content_node_screen_size = self.content_top_node_screen_pos - self.content_bottom_node_screen_pos
    self.content_node_screen_size.x = math.abs(self.content_node_screen_size.x)
    self.content_node_screen_size.y = math.abs(self.content_node_screen_size.y)
end

function Scroll:_apply_size(size)
    self.culling_node_size = gui.get_size(self.culling_node)
    gui.set_size(self.content_node, size)
    self.content_node_size = gui.get_size(self.content_node)
    local horizontal_range = math.max(self.content_node_size.x - self.culling_node_size.x, 0)
    local vertical_range = math.max(self.content_node_size.y - self.culling_node_size.y, 0)
    self.min_x = 0
    self.max_x = -horizontal_range
    self.min_y = 0
    self.max_y = vertical_range
    self:_update_scroll_area_nodes()
end

function Scroll:_apply_bounds()
    local bounds = self.bounds
    if not bounds then return end
    self.culling_node_size = gui.get_size(self.culling_node)

    local min_x = math.min(bounds.min_x, bounds.max_x)
    local max_x = math.max(bounds.min_x, bounds.max_x)
    local min_y = math.min(bounds.min_y, bounds.max_y)
    local max_y = math.max(bounds.min_y, bounds.max_y)
    local half_width = self.culling_node_size.x * 0.5
    local half_height = self.culling_node_size.y * 0.5

    if (max_x - min_x) <= self.culling_node_size.x then
        local center_x = (min_x + max_x) * 0.5
        self.min_x = -center_x
        self.max_x = -center_x
    else
        self.min_x = -(min_x + half_width)
        self.max_x = half_width - max_x
    end

    if (max_y - min_y) <= self.culling_node_size.y then
        local center_y = (min_y + max_y) * 0.5
        self.min_y = -center_y
        self.max_y = -center_y
    else
        self.min_y = half_height - max_y
        self.max_y = -half_height - min_y
    end

    self:_update_scroll_area_nodes()
end

function Scroll:on_resize()
    local current_pos = vmath.vector3(self.scroll_pos)
    self.culling_node_size = gui.get_size(self.culling_node)
    if self.content_mode == "bounds" and self.bounds then
        self:_apply_bounds()
    else
        self:_apply_size(self.content_node_size)
    end
    self:_update_screen_size()
    self:_set_scroll_from_position(current_pos.x, current_pos.y)
end

function Scroll:set_content_size(size)
    local current_pos = vmath.vector3(self.scroll_pos)
    self.content_mode = "size"
    self.bounds = nil
    self:_apply_size(size)
    self:_update_screen_size()
    self:_set_scroll_from_position(current_pos.x, current_pos.y)
end

function Scroll:set_content_bounds(min_x, max_x, min_y, max_y)
    local current_pos = vmath.vector3(self.scroll_pos)
    self.content_mode = "bounds"
    self.bounds = {
        min_x = min_x or 0,
        max_x = max_x or 0,
        min_y = min_y or 0,
        max_y = max_y or 0,
    }
    self:_apply_bounds()
    self:_update_screen_size()
    self:_set_scroll_from_position(current_pos.x, current_pos.y)
end

function Scroll:on_input(action_id, action)
    if (self.ignore_input) then return false end
    --hot fix for mobile input
    if action_id == HASH_TOUCH_MULTI then return false end
    if action_id == HASH_TOUCH_MULTI or action_id == HASH_TOUCH then
        if not self.clickable:on_input(action_id, action) then return false end
        if not self.clickable.pressed then
            self:reset()
            return
        end
        --HANDLE TOUCH
        --action_id touch or multitouch
        if not self.have_scrolled then
            local dy = math.abs((self.clickable.pos_screen.y - self.clickable.pressed_pos_screen.y) / RENDER.screen_size.h)
            local dx = math.abs((self.clickable.pos_screen.x - self.clickable.pressed_pos_screen.x) / RENDER.screen_size.w)

            if dy > 0.025 or dx > 0.025 then
                self.have_scrolled = true
            end
        end
        if self.have_scrolled then
            --scrolling
            local dy = 0
            if self.content_node_screen_size.y ~= 0 then
                dy = self.clickable.pos_screen_delta.y / self.content_node_screen_size.y
            end
            local dx = 0
            if self.content_node_screen_size.x ~= 0 then
                dx = self.clickable.pos_screen_delta.x / self.content_node_screen_size.x
            end
            self.scroll.y = self.scroll.y + dy
            self.scroll.x = self.scroll.x - dx -- x is inverted because moving content left means scrolling right
            self:scroll_to(self.scroll.x, self.scroll.y)
        end
        return self.clickable.consumed
    end

    --HANDLE MOUSE WHEEL
    if (action_id == HASHES.INPUT.SCROLL_UP or action_id == HASHES.INPUT.SCROLL_DOWN) and (INPUT.MOUSE_POS and gui.pick_node(self.culling_node, INPUT.MOUSE_POS.x,
            INPUT.MOUSE_POS.y)) then
        if self.content_node_screen_size.y ~= 0 then
            local dy = self.scroll_wheel / self.content_node_screen_size.y
            if action_id == HASHES.INPUT.SCROLL_UP then
                dy = -dy
            end
            self.scroll.y = self.scroll.y + dy
            self:scroll_to(self.scroll.x, self.scroll.y)
        end
    end

    if self.clickable.pressed_now then
        self.scroll_time = os.time()
    end

    local time = os.time()
    if (time - self.scroll_time) > 1 then
        self.scroll_speed = vmath.vector3(0)
        --self.scroll_speed = math.min(self.scroll_speed + 0.25, 10)
        self.scroll_time = time
    end

    return false
end

---@param x number[0,1]
---@param y number[0,1]
function Scroll:scroll_to(x, y)
    x = LUME.clamp(x or 0, 0, 1)
    y = LUME.clamp(y or 0, 0, 1)

    self.scroll_pos.x = self.min_x + (self.max_x - self.min_x) * x
    self.scroll.x = x

    self.scroll_pos.y = self.min_y + (self.max_y - self.min_y) * y
    self.scroll.y = y

    gui.set_position(self.content_node, self.scroll_pos)
    self:refresh_view()
end

function Scroll:refresh_view()

end

function Scroll:set_ignore_input(ignore)
    self.ignore_input = ignore
    self.clickable:reset()
    self:refresh_view()
end

function Scroll:set_enabled(enable)
    gui.set_enabled(self.culling_node, enable)
end

function Scroll:is_enabled()
    return gui.is_enabled(self.culling_node)
end

return Scroll
