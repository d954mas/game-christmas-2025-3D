local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'

---@class DynamicZEntity
---@field dz number

---@class Entity
---@field dynamic_z DynamicZEntity

---@class UpdateDynamicZSystem:EcsSystem
local System = CLASS.class("UpdateDynamicZSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end
System.filter = ECS.filter("position&dynamic_z")

function System:update()
	local entities = self.entities_list
	for i = 1, #entities do
		---@type Entity
		local e = entities[i]
		e.position.z = self.world.game_world.level_creator.dynamic_z:count_z_pos(e.position.y,e.dynamic_z.dz)
	end
end

return System