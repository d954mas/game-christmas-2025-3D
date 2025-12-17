local CLASS = require "libs.class"
local BaseAction = require "libs.actions.action"

---@class FunctionAction:Action
local Action = CLASS.class("FunctionAction", BaseAction)

function Action.new(fun, save_context) return CLASS.new_instance(Action, fun, save_context) end

function Action:initialize(fun, save_context)
    assert(type(fun) == "function")
    BaseAction.initialize(self, save_context)
    self.fun = fun
end

function Action:act(_)
    self.fun(self)
    return true
end
return Action