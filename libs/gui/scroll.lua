local CLASS = require "libs.class"
local HASHES = require "libs.hashes"
local LUME = require "libs.lume"
local INPUT = require "libs.input"
local Clickable = require "libs.gui.clickable"

local HASH_TOUCH = HASHES.INPUT.TOUCH
local HASH_TOUCH_MULTI = HASHES.INPUT.TOUCH_MULTI

---@class Scroll
local Scroll = CLASS.class("Scroll")

function Scroll.new(culling_node, content_node)
    return CLASS.new_instance(Scroll, culling_node, content_node)
end

function Scroll:reset()
    self.clickable:reset()
    self.have_scrolled = false
    self.scroll_speed = 0
    self.scroll_time = 0
end

function Scroll:initialize(culling_node, content_node)
    self.culling_node = culling_node
    self.content_node = content_node
    self.vertical = true
    self.scroll_pos = vmath.vector3()
    self.scroll = vmath.vector3()
    self.scroll_need_move = 10
    self.culling_node_size = gui.get_size(self.culling_node)
    self.scroll_wheel = 15

    self.content_top_node = gui.new_box_node(vmath.vector3(0), vmath.vector3(1))
    self.content_bottom_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(1))
    gui.set_parent(self.content_top_node, content_node)
    gui.set_parent(self.content_bottom_node, content_node)

    self:set_content_size(gui.get_size(self.content_node))

    -- gui.set_adjust_mode(self.content_bottom_node, gui.ADJUST_STRETCH)
    --gui.set_yanchor(self.content_bottom_node, gui.ANCHOR_BOTTOM)
    --gui.set_visible(self.content_bottom_node, false)


    self.clickable = Clickable.new(self.culling_node)
    self:reset()
    self:on_resize()

    self.ignore_input = false
    self:refresh_view()
end

function Scroll:on_resize()
    self.content_top_node_screen_pos = gui.get_screen_position(self.content_top_node)
    self.content_bottom_node_screen_pos = gui.get_screen_position(self.content_bottom_node)
    self.content_node_screen_size = self.content_top_node_screen_pos - self.content_bottom_node_screen_pos
end

function Scroll:set_content_size(size)
    gui.set_size(self.content_node, size)
    self.content_node_size = gui.get_size(self.content_node)
    self.min_x = 0
    self.max_x = math.max(self.content_node_size.x - self.culling_node_size.x, 0.0001)
    --top bottom
    self.min_y = 0
    self.max_y = math.max((self.content_node_size.y - self.culling_node_size.y), 0.0001)
    gui.set_position(self.content_top_node, vmath.vector3(self.max_x, self.max_y, 0))
    self:scroll_to(self.vertical and self.scroll.y or self.scroll.x)
end

function Scroll:on_input(action_id, action)
    if (self.ignore_input) then return false end
    if action_id == HASH_TOUCH_MULTI or action_id == HASH_TOUCH then
        if not self.clickable:on_input(action_id, action) then return false end
        if not self.clickable.pressed then
            self:reset()
            return
        end
        --HANDLE TOUCH
        --action_id touch or multitouch
        if not self.have_scrolled then
            if self.vertical then
                local dy = math.abs((self.clickable.pos_screen.y - self.clickable.pressed_pos_screen.y) / RENDER.screen_size.h)

                if dy > 0.01 then
                    self.have_scrolled = true
                end
            else
                local dx = math.abs((self.clickable.pos_screen.x - self.clickable.pressed_pos_screen.x) / RENDER.screen_size.w)
                if dx > 0.01 then
                    self.have_scrolled = true
                end
            end
        end
        if self.have_scrolled then
            --scrolling
            if self.vertical then
                local dy = self.clickable.pos_screen_delta.y / self.content_node_screen_size.y
                self.scroll.y = self.scroll.y + dy
                self:scroll_to(self.scroll.y)
            else
                local dx = self.clickable.pos_screen_delta.x / self.content_node_screen_size.x
                self.scroll.x = self.scroll.x + dx
                self:scroll_to(self.scroll.x)
            end
        end
        return self.clickable.consumed
    end

    --HANDLE MOUSE WHEEL
    if (action_id == HASHES.INPUT.SCROLL_UP or action_id == HASHES.INPUT.SCROLL_DOWN) and (INPUT.MOUSE_POS and gui.pick_node(self.culling_node, INPUT.MOUSE_POS.x,
            INPUT.MOUSE_POS.y)) then
        local dy = self.scroll_wheel / self.content_node_screen_size.y
        if action_id == HASHES.INPUT.SCROLL_UP then
            dy = -dy
        end
        if self.vertical then
            self.scroll.y = self.scroll.y + dy
            self:scroll_to(self.scroll.y)
        else
            self.scroll.x = self.scroll.x + dy
            self:scroll_to(self.scroll.y)
        end
    end

    if self.clickable.pressed_now then
        self.scroll_time = os.time()
    end

    local time = os.time()
    if (time - self.scroll_time) > 1 then
        self.scroll_speed = 0
        self.scroll_speed = math.min(self.scroll_speed + 0.25, 10)
        self.scroll_time = time
    end

    return false
end

---@param a number[0,1]
function Scroll:scroll_to(a)
    a = LUME.clamp(a, 0, 1)
    if self.vertical then
        self.scroll_pos.y = self.min_y + (self.max_y - self.min_y) * a
        self.scroll.y = a
    else
        self.scroll_pos.x = self.min_x + (self.max_x - self.min_x) * a
        self.scroll.x = a
    end
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
