local CLASS = require "libs.class"
local BaseAction = require "libs.actions.action"

---@class WaitAction:Action
local Action = CLASS.class("WaitAction", BaseAction)

function Action.new(time) return CLASS.new_instance(Action, time) end

function Action:initialize(time)
	BaseAction.initialize(self, false)
	self.time = time
end

function Action:act(dt)
	self.time = self.time - dt
	return self.time <= 0
end

return Action
