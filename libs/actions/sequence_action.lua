local CLASS = require "libs.class"
local ActionFunction = require "libs.actions.function_action"
local BaseAction = require "libs.actions.action"

---@class SequenceAction:Action
local Action = CLASS.class("SequenceAction", BaseAction)

function Action.new(save_context) return CLASS.new_instance(Action, save_context) end

function Action:initialize(save_context)
	BaseAction.initialize(self, save_context)
	self.sequence = {}
	self.drop_empty = true
end

function Action:act(dt)
	while true do
		local action = self.sequence[1]
		if not action then
			return self.drop_empty
		end

		local result = action:update(dt)
		if result then
			table.remove(self.sequence, 1)
		else
			return false
		end
	end
end

function Action:is_empty()
	return #self.sequence == 0
end

function Action:add_action(action, save_context)
	assert(action)
	if (type(action) == "function") then
		action = ActionFunction.new(action, save_context)
	end
	table.insert(self.sequence, action)
end

function Action:clear()
	self.sequence = {}
end

return Action
