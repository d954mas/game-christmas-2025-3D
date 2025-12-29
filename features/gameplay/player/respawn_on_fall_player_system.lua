local CLASS = require "libs.class"
local ECS = require "libs.ecs"

---@class RespawnOnFallSystem:EcsSystem
local System = CLASS.class("RespawnInWaterSystem", ECS.System)
System.filter = ECS.filter("player")

function System.new() return CLASS.new_instance(System) end

function System:update(_)
    local entities = self.entities_list
    local location_data = self.world.game_world.level_creator.location_data
    for i = 1, #entities do
        ---@class Entity
        local e = entities[i]
        if e.player then
            if not e.respawn_on_fall and e.position.y < -5 then
                e.respawn_on_fall = true
                local target_pos = location_data.data.spawn_position
                self.world.game_world:teleport(e.player_go, target_pos, function ()
                    e.respawn_on_fall = false
                end)
            end
        end
    end
end

return System
