local CLASS = require "libs.class"
local ECS = require 'libs.ecs'


---@class AutoDestroySystem:EcsSystem
local System = CLASS.class("AutoDestroySystem", ECS.System)
System.filter = ECS.filter("auto_destroy_delay")

function System.new() return CLASS.new_instance(System) end

function System:update(dt)
	local entities = self.entities_list
	for i = 1, #entities do
		local e = entities[i]
		e.auto_destroy_delay = e.auto_destroy_delay - dt
		if e.auto_destroy_delay <= 0 then
			self.world:remove_entity(e)
		end
	end
end

return System
