local LOG = require "libs.log"
local HASHES = require "libs.hashes"

local HASH_TOUCH = HASHES.INPUT.TOUCH
local HASH_TOUCH_MULTI = HASHES.INPUT.TOUCH_MULTI

local M = {}

M.PRESSED_KEYS = {}
M.TOUCH = nil
M.MOUSE_POS = nil
M.TOUCH_MULTI = {}
M.IGNORE = false

M.INPUT_LISTENERS = {}


function M.handle_pressed_keys(action_id, action)
    if (action_id == nil) then
        M.MOUSE_POS = action
    elseif (action_id == HASH_TOUCH) then
        if M.TOUCH then
            M.TOUCH.dx = action.x - M.TOUCH.x
            M.TOUCH.dy = action.y - M.TOUCH.y
            M.TOUCH.screen_dx = action.screen_x - M.TOUCH.screen_x
            M.TOUCH.screen_dy = action.screen_y - M.TOUCH.screen_y
        end
        action.id = 0
        M.TOUCH = action
        if (action.released) then
            M.TOUCH = nil
        end
    elseif (action_id == HASH_TOUCH_MULTI and action.touch) then
        for touch_i = 1, #action.touch do
            local touchdata = action.touch[touch_i]
            if (not touchdata.released) then
                --i have no idea but in firefox dx,dy is 0. When move 2 fingers in same frame
                for i = 1, #M.TOUCH_MULTI do
                    local old_action = M.TOUCH_MULTI[i]
                    if old_action.id == touchdata.id then
                        touchdata.dx = touchdata.x - old_action.x
                        touchdata.dy = touchdata.y - old_action.y
                        touchdata.screen_dx = touchdata.screen_x - old_action.screen_x
                        touchdata.screen_dy = touchdata.screen_y - old_action.screen_y
                        break
                    end
                end
            end
        end

        --remove old
        for i = 1, #M.TOUCH_MULTI do M.TOUCH_MULTI[i] = nil end
        for i = 1, #action.touch do
            local touchdata = action.touch[i]
            if (not touchdata.released) then
                table.insert(M.TOUCH_MULTI, touchdata)
            end
        end
    end

    if action_id then
        local data = M.get_key_data(action_id)
        data.just_pressed = false
        if action.pressed then
            data.pressed = true
            data.pressed_time = socket.gettime()
            data.just_pressed = true
        elseif action.released then
            data.pressed = false
        end
    end
end

function M.get_key_data(action_id)
    local data = M.PRESSED_KEYS[action_id]
    if not data then
        data = { pressed = false, pressed_time = 0 }
        M.PRESSED_KEYS[action_id] = data
    end
    return data
end

function M.release(instance)
    instance = assert(instance)
    for i = 1, #M.INPUT_LISTENERS do
        if M.INPUT_LISTENERS[i].instance == instance then
            table.remove(M.INPUT_LISTENERS, i)
            break
        end
    end
end

function M.acquire(instance, priority, scene)
    instance = assert(instance)
    priority = priority or 1
    assert(instance.on_input)
    local inserted = false
    local object = { instance = instance, priority = priority, script_instance = lua_script_instance.Get(), scene = scene }
    for i = 1, #M.INPUT_LISTENERS do
        local listener = M.INPUT_LISTENERS[i]
        if listener.instance == instance then error("listener already registered") end
        if not inserted and listener.priority <= object.priority then
            inserted = true
            table.insert(M.INPUT_LISTENERS, i, object)
        end
    end
    if not inserted then
        table.insert(M.INPUT_LISTENERS, object)
    end
end

function M.global_on_input(action_id, action)
    if M.IGNORE then return end
    local listeners = M.INPUT_LISTENERS
    local current_script_instance = lua_script_instance.Get()
    for i = 1, #listeners do
        local listener = listeners[i]
        if not listener.scene or listener.scene.handle_input then
            if listener.script_instance ~= current_script_instance then
                lua_script_instance.Set(listener.script_instance)
            end

            local ok, error = pcall(listener.instance.on_input, listener.instance, action_id, action)
            if not ok then LOG.e(error, nil) end
            if ok and error then return end

            if listener.script_instance ~= current_script_instance then
                lua_script_instance.Set(current_script_instance)
            end
        end
    end
end

return M
