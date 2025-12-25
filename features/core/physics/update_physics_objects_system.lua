local CLASS = require "libs.class"
local ECS = require 'libs.ecs'


---@class UpdatePhysicsObjectsSystem:EcsSystem
local System = CLASS.class("UpdatePhysicsObjectsSystem", ECS.System)

function System.new() return CLASS.new_instance(System) end

function System:update()
	physics_utils.physics_objects_update_variables()
end

return System
