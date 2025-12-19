local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local BOX2D_FEATURE = require "features.core.box2d.box2d_feature"
local CONSTANTS = require "libs.constants"

---@class DrawBox2dPhysicsDebugSystem:EcsSystem
local System = CLASS.class("DrawBox2dPhysicsDebugSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

function System:initialize()
    ECS.System.initialize(self)
    self.enable_physics = false
end

function System:draw(_)
    if (CONSTANTS.VERSION_IS_DEV) then
        if (self.enable_physics ~= BOX2D_FEATURE.storage:is_draw_debug()) then
            self.enable_physics = BOX2D_FEATURE.storage:is_draw_debug()

            local b2_world = self.world.game_world.box2d_world
            if (self.enable_physics) then
                b2_world:draw_debug_data_set_enabled(true)
                b2_world.world:SetDebugDraw(b2_world.debug_draw)
            else
                b2_world:draw_debug_data_set_enabled(false)
                b2_world.world:SetDebugDraw(nil)
            end
        end
        if(self.enable_physics)then
            self.world.game_world.box2d_world.world:DebugDraw()
        end
    end
end


return System