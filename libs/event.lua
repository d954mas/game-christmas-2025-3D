local CLASS = require "libs.class"
local LOG = require "libs.log"

---@class Event
local Event = CLASS.class("EventClass")

function Event.new(name)
	return CLASS.new_instance(Event, name)
end

function Event:initialize(name)
	self.name = assert(name)
	self.callbacks = {}
end

function Event:subscribe(save_context, callback)
	assert(type(callback) == "function")

	if self:is_subscribed(callback) then
		LOG.e("Event:" .. self.name .. " is already subscribed", nil, 3)
		return
	end

	table.insert(self.callbacks, {
		callback = callback,
		script_context = save_context and lua_script_instance.Get()
	})

	return function () self:unsubscribe(callback) end
end

function Event:unsubscribe(callback)
	assert(type(callback) == "function")

	for index = 1, #self.callbacks do
		local cb = self.callbacks[index]
		if cb.callback == callback then
			table.remove(self.callbacks, index)
			return true
		end
	end

	return false
end

function Event:is_subscribed(callback)
	for index = 1, #self.callbacks do
		if self.callbacks[index] == callback then return true end
	end

	return false
end

--- Trigger the event
-- @function event.trigger
-- @tparam args args The args for event trigger
function Event:trigger(...)
	local current_script_context = lua_script_instance.Get()

	for index = 1, #self.callbacks do
		local callback = self.callbacks[index]
		local change_script_context = callback.script_context and current_script_context ~= callback.script_context
		if change_script_context then
			lua_script_instance.Set(callback.script_context)
		end

		local ok, error = pcall(callback.callback, self, ...)
		if not ok then LOG.e(error) end

		if change_script_context then
			lua_script_instance.Set(current_script_context)
		end
	end
end

return Event
