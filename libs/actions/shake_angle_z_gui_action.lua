local CLASS = require "libs.class"
local BaseAction = require "libs.actions.action"
local PERLIN = require "libs.perlin"
local CHECKS = require "libs.checks"

local CHECKS_CONFIG = {
	delay = "?number",
	time = "number",
	easing = "function",
	angle = "number",
	perlin_power = "number",
	object = "userdata"
}

---@class GuiShakeRotationZAction:Action
local Action = CLASS.class("GuiShakeRotationZAction", BaseAction)

function Action.new_noctx(config) return CLASS.new_instance(Action, config, false) end

function Action.new_ctx(config) return CLASS.new_instance(Action, config, true) end

function Action:initialize(config, save_context)
	CHECKS("?", CHECKS_CONFIG, "?boolean")
	BaseAction.initialize(self, save_context)
	self.config = config

	self.perlin_seed = math.random(256)
	self.time_passed = 0
	self.delay_time = 0

	self.euler = gui.get_euler(self.config.object)
	self.euler_result = vmath.vector3(self.euler)
end

function Action:set_property()
	local t = self.time_passed
	local duration = self.config.time
	local a = 1 - self.config.easing(t, 0, 1, duration)

	local noise = PERLIN.noise(t * self.config.perlin_power, self.perlin_seed, 0)
	local shake_angle = self.config.angle * a * noise

	local final_angle = self.euler.z + shake_angle
	self.euler_result.z = final_angle
	gui.set_euler(self.config.object, self.euler_result)
end

function Action:act(dt)
	if self.config.delay then
		self.delay_time = self.delay_time + dt
		if self.delay_time < self.config.delay then
			return false
		end
	end

	if self.time_passed < self.config.time then
		self.time_passed = self.time_passed + dt
		self:set_property()
		return false
	end

	-- Reset to original
	gui.set_euler(self.config.object, self.euler)
	return true
end

return Action
