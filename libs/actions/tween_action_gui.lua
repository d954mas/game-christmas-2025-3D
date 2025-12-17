local CLASS = require "libs.class"
local TweenAction = require "libs.actions.tween_action"

---@class TweenActionGui:TweenAction
local Action = CLASS.class("TweenActionGui", TweenAction)

function Action.new_noctx(config) return CLASS.new_instance(Action, config, false) end
function Action.new_ctx(config) return CLASS.new_instance(Action, config, true) end
function Action.new(config) return CLASS.new_instance(Action, config, true) end

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
	if self.config.property == "position" then
		return self:config_value_to_table(gui.get_position(self.config.object))
	end
	if self.config.property == "scale" then
		return self:config_value_to_table(gui.get_scale(self.config.object))
	end
	local data = gui.get(self.config.object, self.property_hash)
	return self:config_value_to_table(data)
end

function Action:set_property()
	gui.set(self.config.object, self.property_hash, self:config_table_to_value(self.tween_subject))
end

return Action
