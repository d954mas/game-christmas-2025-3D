local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local ENUMS = require "game.enums"

local TARGET_V = vmath.vector3()
local VMATH_DOT = vmath.dot
local VMATH_LENGTH = vmath.length
local MATH_ABS = math.abs

---@class PlayerMoveBox2dSystem:EcsSystem
local System = CLASS.class("PlayerMoveBox2dSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

System.filter = ECS.filter("player")

local TEMP_V = vmath.vector3(0)

function System:update(dt)
    local entities = self.entities_list
    for i = 1, #entities do
        self:process(entities[i], dt)
    end
end

---@param e Entity
function System:process(e, dt)
    local v_move = TEMP_V
    if e.knockback then
        e.moving = true
        if e.knockback.time == 0 then
            local mul = 6
            local mul_top = 3
            v_move.x, v_move.y = 0, 0
            e.body:SetLinearVelocity(v_move)
            e.body:ApplyForceToCenter(e.knockback.direction * mul * 1200, true)
            e.body:ApplyForceToCenter(vmath.vector3(0, 500 * mul_top, 0), true)
        end
        e.knockback.time = e.knockback.time + dt
        if e.knockback.time > e.knockback.time_max then
            ---@diagnostic disable-next-line: inject-field
            e.knockback = nil
            self.world:add_entity(e)
        end
    else
        local movement = e.movement
        local max_speed =movement.max_speed
		max_speed = max_speed * movement.max_speed_limit

        local velocity = e.body:GetLinearVelocity()
        if (movement.input.x == 0 and movement.input.y == 0) then
			movement.direction.x, movement.direction.y = 0, 0
		else
			xmath.normalize(movement.direction, movement.input)
		end

		xmath.mul(TARGET_V, movement.direction, max_speed)


		local is_accel = VMATH_DOT(TARGET_V, movement.velocity) > 0
		local accel = is_accel and movement.accel or movement.deaccel

		if (movement.input.x == 0 and movement.input.y == 0) then
			xmath.lerp(movement.velocity, movement.deaccel_stop, velocity, TARGET_V)
		else
			xmath.lerp(movement.velocity, accel, velocity, TARGET_V)
		end



		if (VMATH_LENGTH(movement.velocity) < 0.001) then
			movement.velocity.x = 0
			movement.velocity.y = 0
		end
		--endregion

		e.moving = (MATH_ABS(movement.velocity.x) > 0 or MATH_ABS(movement.velocity.y) > 0)
			and (MATH_ABS(movement.direction.x) > 0 or MATH_ABS(movement.direction.y) > 0)

        v_move.x = movement.velocity.x
        v_move.y = movement.velocity.y

        if e.moving then
            --at zero keep current
            if (e.movement.direction.x > 0) then
                e.look_at = ENUMS.DIRECTION.RIGHT
            elseif (e.movement.direction.x < 0) then
                e.look_at = ENUMS.DIRECTION.LEFT
            end
        end
          e.body:SetLinearVelocity(v_move)

        --SIMPLE
        --[[
        if (not e.moving) then
            v_move.x, v_move.y = 0, 0
        else
            xmath.mul(TEMP_V, e.movement.direction, dt)
            --PLAYER TILE
           -- local level = self.world.game_world.level_creator.level
           -- local tile_size = BALANCE.config.tile_size
           -- local coord_x = e.position.x / tile_size
          --  local coord_y = e.position.y / tile_size

           -- local tile_coord = level:coords_to_id(coord_x, coord_y)
          --  local tile_data = level.data.ground[tile_coord]
            --local tile = level:get_tile(tile_data.id)

            local speed = e.movement.max_speed

            xmath.mul(TEMP_V, TEMP_V, speed)
            if (e.movement.direction.x > 0) then
                e.look_at = ENUMS.DIRECTION.RIGHT
            elseif (e.movement.direction.x < 0) then
                e.look_at = ENUMS.DIRECTION.LEFT
            end
        end
        e.body:SetLinearVelocity(v_move)--]]
    end
end

return System
