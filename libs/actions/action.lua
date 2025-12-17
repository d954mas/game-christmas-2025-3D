local CLASS = require "libs.class"
local CONTEXTS = require "libs.contexts_manager"
local LOG = require "libs.log"

---@class Action:BaseClass
local Action = CLASS.class("Action")

function Action:initialize(save_context)
	if save_context or save_context == nil then self.context = lua_script_instance.Get() end
	self.finished = false
	self.speed = 1
end

function Action:is_finished()
	return self.finished
end

function Action:update(dt)
	if self.finished then return true end
	dt = dt * self.speed
	local ctx = self.context and CONTEXTS:set_context_top_by_instance(self.context)
	local status, result = pcall(self.act, self, dt)
	if status then
		self.finished = result
	else
		self.finished = true
		LOG.e("Error in action:" .. self.__class.name .. " " .. result, nil, 3)
	end
	if ctx then ctx:remove() end
end

---@param dt number
---@return boolean true if action is done it work
---@diagnostic disable-next-line: unused-local
function Action:act(dt) return true end

return Action
