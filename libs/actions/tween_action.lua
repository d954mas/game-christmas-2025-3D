local CLASS = require "libs.class"
local CHECKS = require "libs.checks"
local BaseAction = require "libs.actions.action"
local TWEEN = require "libs.tween"

local CHECKS_CONFIG = {
	delay = "?number",
	to = "?",
	from = "?",
	by = "?table",
	object = "table|userdata|string",
	property = "string|userdata",
	time = "number",
	easing = "string|function|nil",
}

---@class TweenAction:Action
---tween worked only with tables. So convert v3,v4,quaternion to table
local Action = CLASS.class("TweenAction", BaseAction)

function Action:initialize(config, save_context)
	CHECKS("?", CHECKS_CONFIG, "?boolean")
	assert(config.by ~= config.to, "Need by or to in config")
	BaseAction.initialize(self, save_context)
	self.config = config
	self:reset()
end

function Action:reset()
	self.delay_time = 0
	if self.tween then self.tween:reset() end
end

function Action:act(dt)
	if self.config.delay then
		self.delay_time = self.delay_time + dt
		if self.delay_time < self.config.delay then return false end
	end

	if not self.tween then
		self.tween_subject = self.config.from and self:config_value_to_table(self.config.from) or self:config_get_from()
		self.tween_to = self.config.to and self:config_value_to_table(self.config.to) or self:config_get_to()
		self.tween = TWEEN.new(self.config.time, self.tween_subject, self.tween_to, self.config.easing)
	end

	local result = self.tween:update(dt)
	self:set_property()
	return result
end

function Action:config_value_to_table(data)
	assert(data)
	local type_data = type(data)
	if type_data == "number" then
		return { data }
	elseif type_data == "table" then
		return data
	elseif type_data == "userdata" then
		if xmath.is_vector3(data) then
			self.v3 = vmath.vector3(data)
			return { x = data.x, y = data.y, z = data.z }
		elseif xmath.is_vector4(data) then
			self.v4 = vmath.vector4(data)
			return { x = data.x, y = data.y, z = data.z, w = data.w }
		elseif xmath.is_quat(data) then
			assert("for quaternion tweening is not correct. Use some kind of lerp instead")
		end
		error("unknown userdata")
	end
	error("unknown type:" .. type_data)
end

function Action:config_get_to()
	if self.config.by then
		local to = self:config_value_to_table(self.config.by)
		for k, v in pairs(to) do
			to[k] = v + self.config.from[k]
		end
	end
	error("can't be here.  Need from value")
end

function Action:config_table_to_value(data)
	if self.v3 then
		self.v3.x = data.x
		self.v3.y = data.y
		self.v3.z = data.z
		return self.v3
	elseif self.v4 then
		self.v4.x = data.x
		self.v4.y = data.y
		self.v4.z = data.z
		self.v4.w = data.w
		return self.v4
	end

	if data[self.config.property] then
		return data[self.config.property]
	end

	if data[1] then
		return data[1]
	end
	error("can't convert data to value")
end

function Action:config_get_from()
	error("need impl")
end

--region set_value
function Action:set_property()
	error("need impl")
end

return Action
