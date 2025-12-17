local CLASS = require "libs.class"
local TweenAction = require "libs.actions.tween_action"

---@class TweenActionTable:TweenAction
local Action = CLASS.class("TweenActionTable", TweenAction)

function Action.new_noctx(config) return CLASS.new_instance(Action, config, false) end
function Action.new_ctx(config) return CLASS.new_instance(Action, config, true) end

function Action:set_property()
	self.config.object[self.config.property] = self:config_table_to_value(self.tween_subject)
end

function Action:config_get_from()
	local data = assert(self.config.object[self.config.property], "no property in table:" .. self.config.property)
	return self:config_value_to_table(data)
end

return Action
