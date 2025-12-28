local ECS = require 'libs.ecs'
local CLASS = require "libs.class"

local TEMP_V = vmath.vector3()
local RAYCAST_FROM = vmath.vector3()
local RAYCAST_V = vmath.vector3(0, -0.2, 0)
local RAYCAST_START_DY = 0.5

local DIR_UP = vmath.vector3(0, 1, 0)

local points = {
    vmath.vector3(0, 0, 0),
    vmath.vector3(0.2, 0, 0),
    vmath.vector3(-0.2, 0, 0),
    vmath.vector3(0, 0, 0.2),
    vmath.vector3(0, 0, -0.2),
}


---@class PlayerGroundCheckSystem:EcsSystem
local System = CLASS.class("PlayerGroundCheckSystem", ECS.System)
System.filter = ECS.filter("grounded")

function System.new() return CLASS.new_instance(System) end

function System:initialize()
    ECS.System.initialize(self)
    self.ground_raycast_groups = {
        hash("geometry"),
        hash("obstacle"),
        hash("geometry_block_view")
    }
    self.ground_raycast_mask = physics_utils.physics_count_mask(self.ground_raycast_groups)
end

function System:update(_)
    local entities = self.entities_list
    for i = 1, #entities do
        local e = entities[i]
        --add RAYCAST_START_DY to avoid raycast from edge of earth
        RAYCAST_FROM.x, RAYCAST_FROM.y, RAYCAST_FROM.z = e.position.x, e.position.y + RAYCAST_START_DY, e.position.z
        TEMP_V.x, TEMP_V.y, TEMP_V.z = e.position.x, e.position.y + RAYCAST_V.y, e.position.z

        ---@diagnostic disable-next-line: unused-local
        local exist, x, y, z, nx, ny, nz, collision_hash
        for idx = 1, #points do
            local point = points[idx]
            RAYCAST_FROM.x, RAYCAST_FROM.z = e.position.x + point.x, e.position.z + point.z
            TEMP_V.x, TEMP_V.z = RAYCAST_FROM.x, RAYCAST_FROM.z

            ---@diagnostic disable-next-line: unused-local
            exist, x, y, z, nx, ny, nz, collision_hash = physics_utils.physics_raycast_single(RAYCAST_FROM, TEMP_V, self.ground_raycast_mask)
            if (exist) then
                -- if (idx ~= 1) then
                --   print("idx:" .. idx)
                --  nx, ny, nz = DIR_UP.x, DIR_UP.y, DIR_UP.z
                --end
                break
            end
        end
        if exist then
            -- local object = self.world.game_world.level_creator.entities.collision_to_object[collision_hash]
            --            if object and object.object_config.type == DEFS.OBJECTS.TYPES.MATERIALS.OBJECTS.WINDOW_UNSAFE.id then
            --broke windows
            --   self.world:remove_entity(object)
            --   return
            -- end

            if (not e.grounded.on_ground) then
                -- self.world.game_world.sounds:jump_land()
            end
            --	for _, result in ipairs(results) do
            e.grounded.on_ground_time = self.world.game_world.state.time
            e.grounded.on_ground = true
            e.grounded.collision_hash = collision_hash
            ---@diagnostic disable-next-line: assign-type-mismatch
            e.grounded.normal.x, e.grounded.normal.y, e.grounded.normal.z = nx, ny, nz
            --	end
        else
            e.grounded.on_ground = false
            e.grounded.collision_hash = nil
            e.grounded.normal.x, e.grounded.normal.y, e.grounded.normal.z = DIR_UP.x, DIR_UP.y, DIR_UP.z

            if (self.world.game_world.state.time - e.movement.physics_reset_y_velocity > 0.1 and not e.jump.in_jump) then
                --e.in_jump = true--only once reset it
                e.movement.physics_reset_y_velocity = self.world.game_world.state.time
                --reset y velocity
                local vel = e.physics_linear_velocity
                if (vel.y > 10) then
                    vel.y = vel.y * 0.5
                elseif (vel.y > 3) then
                    vel.y = vel.y * 0.75
                end
            end
        end
    end
end

return System
