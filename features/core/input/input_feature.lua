local INPUT = require "features.core.input.input"

local M = {}

function M:init()
    msg.post(".", "acquire_input_focus")
end

function M:on_input(action_id,action)
    INPUT.handle_pressed_keys(action_id, action)
	INPUT.global_on_input(action_id, action)
end

return M
