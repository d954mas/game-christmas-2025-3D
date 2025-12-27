local CLASS = require "libs.class"
local ECS = require 'libs.ecs'
local HASHES = require "libs.hashes"

local TARGET_V = vmath.vector3()

local QUAT_YAW = vmath.quat_rotation_y(0)

local V_UP = vmath.vector3(0, 1, 0)
local IMPULSE_V = vmath.vector3()

local VMATH_DOT = vmath.dot
local VMATH_LENGTH = vmath.length
local MATH_ABS = math.abs

local TEMP_V = vmath.vector3()
local RAYCAST_FROM = vmath.vector3()
local RAYCAST_START_DY = 0.1
local RAYCAST_START_DY_2 = 1

local RAYCAST_NORMAL = vmath.vector3()

local FORCE_TABLE = {
    { force = vmath.vector3(0, 0, 0), position = vmath.vector3() },
}

---@class PlayerMoveSystem:EcsSystem
local System = CLASS.class("PlayerMoveSystem", ECS.System)
System.filter = ECS.filter("player")

function System.new() return CLASS.new_instance(System) end

function System:initialize()
    ECS.System.initialize(self)
    self.ground_raycast_groups = {
        hash("geometry"),
        hash("obstacle"),
        hash("geometry_block_view"),
    }
    self.ground_raycast_mask = physics_utils.physics_count_mask(self.ground_raycast_groups)
end

function System:update()
    local time = self.world.game_world.state.time
    local entities = self.entities_list
    for i = 1, #entities do
        local e = entities[i]
        local movement = e.movement

        local delta_ground_time = (time - e.grounded.on_ground_time)
        local use_ground_normal = not e.jump.in_jump and (e.grounded.on_ground or delta_ground_time < 0.1)

        movement.direction.x = 0
        movement.direction.y = 0
        movement.direction.z = 0

        if movement.input.x ~= 0 or movement.input.z ~= 0 then
            movement.direction.x = movement.input.x
            movement.direction.z = movement.input.z
            xmath.normalize(movement.direction, movement.direction)
        end

        xmath.quat_rotation_y(QUAT_YAW, math.rad(e.camera.rotation_euler.y))
        xmath.rotate(movement.direction, QUAT_YAW, movement.direction)


        if use_ground_normal and vmath.length(movement.direction) > 0 then
            --ignore if normal look up it can be like
            --vmath.vector3(-7.1524499389852e-07, 1, 1.3351240340853e-05) so ignore that
            if (e.grounded.normal.y ~= 1) then
                xmath.cross(movement.direction, e.grounded.normal, movement.direction)
                xmath.cross(movement.direction, movement.direction, e.grounded.normal)
                if (movement.direction.y > 0) then
                    movement.direction.y = movement.direction.y * 0.9
                    --reduce y movement to avoid player start fly
                end
            end
            xmath.normalize(movement.direction, movement.direction)
        end


        --region GROUND MOVEMENT
        local max_speed = movement.input.z ~= 0 and movement.max_speed or movement.max_speed * movement.strafe_power
        max_speed = max_speed * movement.max_speed_limit

        xmath.mul(TARGET_V, movement.direction, max_speed)

        local is_accel = VMATH_DOT(TARGET_V, movement.velocity) > 0


        local accel = is_accel and movement.accel or movement.deaccel

        if (movement.input.x == 0 and movement.input.z == 0) then
            xmath.lerp(movement.velocity, movement.deaccel_stop, e.physics_linear_velocity, TARGET_V)
            --	movement.velocity.y = 0
        else
            xmath.lerp(movement.velocity, accel, e.physics_linear_velocity, TARGET_V)
        end



        if (VMATH_LENGTH(movement.velocity) < 0.001) then
            movement.velocity.x = 0
            --movement.velocity.y = 0
            movement.velocity.z = 0
        end
        if use_ground_normal then
            e.physics_linear_velocity.y = movement.velocity.y
        end
        e.physics_linear_velocity.x = movement.velocity.x
        e.physics_linear_velocity.z = movement.velocity.z
        --endregion

        e.moving = (MATH_ABS(movement.velocity.x) > 0 or MATH_ABS(movement.velocity.z) > 0)
            and (MATH_ABS(movement.direction.x) > 0 or MATH_ABS(movement.direction.z) > 0)

        --if (e.moving) then PHYSICS_WAKEUP(e.player_go.collision) end
        physics.wakeup(e.player_go.physics.collision)

        if (e.grounded.on_ground and delta_ground_time < 0.1) then
            e.jump.idx = 0
        end

        if (e.moving) then
            e.look_dir.x = e.movement.direction.x
            e.look_dir.z = e.movement.direction.z
            if vmath.length(e.look_dir) > 0 then
                xmath.normalize(e.look_dir, e.look_dir)
                --xmath.rotate(e.look_dir, QUAT_YAW, LOOK_FORWARD)
            end
            --xmath.rotate(e.look_dir, QUAT_YAW, LOOK_FORWARD)
        end




        local need_force = false
        if (e.movement.pressed_jump) then
            e.movement.pressed_jump = false
            --2 frames min stay on ground before next jump or player can have strange jumps
            local on_ground = (e.grounded.on_ground and delta_ground_time > (0.167 * 2))
                or delta_ground_time < 0.1                --coyote time
                or (e.jump.idx > 0 and e.jump.idx < e.jump.max_jumps) --second jump worked on air

            if (on_ground and ((e.jump.idx == 0 and (time - e.jump.last_time > 0.5)) or (e.jump.idx > 0 and (time - e.jump.last_time > 0.1)))) then
                e.jump.last_time = time
                e.jump.in_jump = true
                e.jump.idx = e.jump.idx + 1
                xmath.mul(IMPULSE_V, V_UP, e.jump.power)

                e.physics_linear_velocity.y = 0
                e.movement.physics_reset_y_velocity = time
                need_force = true
            end
        end

        e.jump.in_jump = time - e.jump.last_time < (0.167 * 3)

        if (need_force) then
            FORCE_TABLE.force = IMPULSE_V
            FORCE_TABLE.position = e.position
            msg.post(e.player_go.physics.collision, HASHES.PHYSICS.APPLY_FORCE, FORCE_TABLE)
        end

        if e.moving then
            --[[if not self.world.game_world.state.first_move then
				self.world.game_world.state.first_move = true
				local ctx = CONTEXTS:set_context_top_game_gui()
				ctx.data:hide_tooltip_input()
				ctx:remove()
			end--]]
        end

        if e.moving and e.grounded and not e.jump.in_jump then
            RAYCAST_FROM.x, RAYCAST_FROM.y, RAYCAST_FROM.z = e.position.x, e.position.y + RAYCAST_START_DY, e.position.z
            TEMP_V.x, TEMP_V.y, TEMP_V.z = RAYCAST_FROM.x, RAYCAST_FROM.y, RAYCAST_FROM.z
            TEMP_V.x = TEMP_V.x + e.movement.direction.x * 0.8
            TEMP_V.z = TEMP_V.z + e.movement.direction.z * 0.8
            local exist, _, _, _, nx, ny, nz, _ = physics_utils.physics_raycast_single(RAYCAST_FROM, TEMP_V, self.ground_raycast_mask)
            if (exist) then
                ---@diagnostic disable-next-line: assign-type-mismatch
                RAYCAST_NORMAL.x, RAYCAST_NORMAL.y, RAYCAST_NORMAL.z = nx, ny, nz
                local dot = vmath.dot(e.movement.direction, RAYCAST_NORMAL)
                --blocked by wall
                if dot < -0.90 then
                    RAYCAST_FROM.x, RAYCAST_FROM.y, RAYCAST_FROM.z = e.position.x, e.position.y + RAYCAST_START_DY_2, e.position.z
                    TEMP_V.x, TEMP_V.y, TEMP_V.z = RAYCAST_FROM.x, RAYCAST_FROM.y, RAYCAST_FROM.z
                    TEMP_V.x = TEMP_V.x + e.movement.direction.x * 0.8
                    TEMP_V.z = TEMP_V.z + e.movement.direction.z * 0.8
                    exist, _, _, _, nx, ny, nz, _ = physics_utils.physics_raycast_single(RAYCAST_FROM, TEMP_V, self.ground_raycast_mask)
                    if not exist then
                        --can apply force. Player blocked by small wall
                        --move up to step on small stairs
                        TEMP_V.x = e.movement.direction.x
                        TEMP_V.z = e.movement.direction.z
                        TEMP_V.y = 2
                        xmath.normalize(TEMP_V, TEMP_V)
                        xmath.mul(TEMP_V, TEMP_V, 2000)
                        FORCE_TABLE.force = TEMP_V
                        FORCE_TABLE.position = e.position
                        msg.post(e.player_go.physics.collision, HASHES.PHYSICS.APPLY_FORCE, FORCE_TABLE)
                    end
                end
            end
        end
    end
end

return System
