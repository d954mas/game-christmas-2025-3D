local CLASS = require "libs.class"
local BaseAction = require "libs.actions.action"

---@class FunctionComplexAction:Action
local Action = CLASS.class("FunctionAction", BaseAction)

function Action.new(fun, save_context) return CLASS.new_instance(Action, fun, save_context) end

function Action:initialize(fun, save_context)
    assert(type(fun) == "function")
    BaseAction.initialize(self, save_context)
    self.fun = fun
    self.step = 0
end

function Action:next_step()
    self.step = self.step + 1
end

function Action:act(dt)
    return self.fun(self, dt)
end
return Action