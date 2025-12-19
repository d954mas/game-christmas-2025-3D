local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'

---@class Box2dUpdateSystem:EcsSystem
local System = CLASS.class("Box2dUpdateSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

function System:initialize()
    ECS.System.initialize(self)
end

function System:update()
    self.world.game_world.box2d_world:update()
end


return System