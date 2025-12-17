local CLASS = require "libs.class"
local HASHES = require "libs.hashes"

local HASH_TOUCH = HASHES.INPUT.TOUCH
local HASH_TOUCH_MULTI = HASHES.INPUT.TOUCH_MULTI


----@class Clickable
local Clickable = CLASS.class("Clickable")

function Clickable.new(root_node)
    return CLASS.new_instance(Clickable, root_node)
end

function Clickable:initialize(root_node)
    self.root_node = assert(root_node)
    self.enabled = false
    self.pressed_pos = vmath.vector3(0, 0, 0)
    self.pos = vmath.vector3(0, 0, 0)
    self.pos_delta = vmath.vector3(0, 0, 0)

    self.pressed_pos_screen = vmath.vector3(0, 0, 0)
    self.pos_screen = vmath.vector3(0, 0, 0)
    self.pos_screen_delta = vmath.vector3(0, 0, 0)

    self:reset()
end

function Clickable:reset()
    self.over_now = false
    self.out_now = false
    self.over = false
    self.pressed_now = false
    self.released_now = false
    self.consumed = false
    self.clicked = false
    self.pressed = false
    self.touch_id = nil
    self.action_x = 0
    self.action_y = 0
    self.action_dx = 0
    self.action_dy = 0
    self.pressed_pos.x, self.pressed_pos.y = 0, 0
    self.pos.x, self.pos.y = 0, 0
    self.pos_delta.x, self.pos_delta.y = 0, 0

    self.pressed_pos_screen.x, self.pressed_pos_screen.y = 0, 0
    self.pos_screen.x, self.pos_screen.y = 0, 0
    self.pos_screen_delta.x, self.pos_screen_delta.y = 0, 0
end

function Clickable:handle_action(action)
    local touch_id = action.id or 0
    if not self.touch_id or self.touch_id == touch_id then
        local over = gui.pick_node(self.root_node, action.x, action.y)

        local pressed = action.pressed and over
        local released = action.released
        local need_handle = (not self.touch_id and pressed) or self.touch_id == touch_id
        if not need_handle then return false end

        if pressed then
            self.touch_id = touch_id
        elseif released then
            self.touch_id = nil
        end

        self.over_now = over and not self.over
        self.out_now = not over and self.over
        self.over = over


        self.pressed_now = pressed and not self.pressed
        self.released_now = released and self.pressed
        self.pressed = pressed or (self.pressed and not released)
        self.consumed = self.pressed or (self.released_now and self.over)
        self.clicked = self.released_now and self.over
        if self.pressed_now then
            self.pressed_pos.x, self.pressed_pos.y = action.x, action.y
            self.pos.x, self.pos.y = action.x, action.y
            self.pressed_pos_screen.x, self.pressed_pos_screen.y = action.screen_x, action.screen_y
            self.pos_screen.x, self.pos_screen.y = action.screen_x, action.screen_y
        end
        self.pos_delta.x, self.pos_delta.y = action.x - self.pos.x, action.y - self.pos.y
        self.pos.x, self.pos.y = action.x, action.y
        self.pos_screen_delta.x, self.pos_screen_delta.y = action.screen_x - self.pos_screen.x, action.screen_y - self.pos_screen.y
        self.pos_screen.x, self.pos_screen.y = action.screen_x, action.screen_y
        return true
    end
    return false
end

function Clickable:on_input(action_id, action)
    if (action_id and action_id ~= HASH_TOUCH and action_id ~= HASH_TOUCH_MULTI) then return false end

    self.enabled = gui.is_enabled(self.root_node, true)
    if not self.enabled or not action then
        self:reset()
        return true
    end

    if not action.touch then
        return self:handle_action(action)
    else
        for _, touch_action in ipairs(action.touch) do
            if self:handle_action(touch_action) then return true end
        end
    end
    return false
end

return Clickable
