local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'

---@class GoPositionSetterUpdateSystem:EcsSystem
local System = CLASS.class("GoPositionSetterUpdateSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end


function System:update()
    self.world.game_world.ecs.entities.go_position_setter:update()
end


return System