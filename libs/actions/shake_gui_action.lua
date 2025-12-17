local CLASS = require "libs.class"
local BaseAction = require "libs.actions.action"
local PERLIN = require "libs.perlin"
local CHECKS = require "libs.checks"

local CHECKS_CONFIG = {
	delay = "?number",
	time = "number",
	easing = "function",
	x = "number",
	y = "number",
	perlin_power = "number",
	object = "userdata"
}

---@class GuiShakeAction:Action
local Action = CLASS.class("GuiShakeAction", BaseAction)

function Action.new_noctx(config) return CLASS.new_instance(Action, config, false) end
function Action.new_ctx(config) return CLASS.new_instance(Action, config, true) end

function Action:initialize(config, save_context)
	CHECKS("?", CHECKS_CONFIG, "?boolean")
	BaseAction.initialize(self, save_context)
	self.config = config

	self.perlin_seeds = {
		math.random(256),
		math.random(256)
	}

	self.start_position = vmath.vector3(gui.get_position(self.config.object))
	self.position_result = vmath.vector3(self.start_position)

	self.time_passed = 0
	self.delay_time = 0
end

function Action:set_property()
	local t = self.time_passed
	local duration = self.config.time
	local a = 1 - self.config.easing(t, 0, 1, duration)

	local offset_x = self.config.x * a * PERLIN.noise(t * self.config.perlin_power, 0, self.perlin_seeds[1])
	local offset_y = self.config.y * a * PERLIN.noise(t * self.config.perlin_power, 0, self.perlin_seeds[2])

	self.position_result.x = self.start_position.x + offset_x
	self.position_result.y = self.start_position.y + offset_y

	gui.set_position(self.config.object, self.position_result)
end

function Action:act(dt)
	-- Handle delay if any
	if self.config.delay then
		self.delay_time = self.delay_time + dt
		if self.delay_time < self.config.delay then
			return false
		end
	end

	-- Animate shake
	if self.time_passed < self.config.time then
		self.time_passed = self.time_passed + dt
		self:set_property()
		return false
	end

	-- End of shake: restore original position
	gui.set_position(self.config.object, self.start_position)
	return true
end

return Action
