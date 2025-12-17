local CLASS = require "libs.class"
local TweenAction = require "libs.actions.tween_action"

---@class TweenActionGO:TweenAction
local Action = CLASS.class("TweenGOAction", TweenAction)

function Action.new_noctx(config) return CLASS.new_instance(Action, config, false) end

function Action.new_ctx(config) return CLASS.new_instance(Action, config, true) end

function Action.new(config, save_context) return CLASS.new_instance(Action, config, save_context) end

function Action:initialize(config, save_context)
	local type_property = type(config.property)
	if type_property == "string" then
		self.property_hash = hash(config.property)
	elseif type_property == "userdata" then
		self.property_hash = config.property
	end
	TweenAction.initialize(self, config, save_context)
end

function Action:config_get_from()
	local data = go.get(self.config.object, self.property_hash)
	return self:config_value_to_table(data)
end

function Action:set_property()
	return go.set(self.config.object, self.property_hash, self:config_table_to_value(self.tween_subject))
end

return Action
