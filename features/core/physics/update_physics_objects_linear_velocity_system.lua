local CLASS = require "libs.class"
local ECS = require 'libs.ecs'


---@class UpdatePhysicsObjectsLinearVelocitySystem:EcsSystem
local System = CLASS.class("UpdatePhysicsObjectsLinearVelocitySystem", ECS.System)

function System.new() return CLASS.new_instance(System) end

function System:update()
	physics_utils.physics_objects_update_linear_velocity()
end

return System
