local CLASS = require "libs.class"
local ENUMS = require "game.enums"
local BALANCE = require "game.balance"

---@class Entity
---@field auto_destroy_delay number
---@field auto_destroy bool
---@field body Box2dBody
---@field level_map_object LevelMapObject
---@field tile_data LevelMapTile


local Entities = CLASS.class("Entities")

function Entities.new(game_world) return CLASS.new_instance(Entities, game_world) end

---@param game_world GameWorld2D|GameWorld3D
function Entities:initialize(game_world)
    self.game_world = assert(game_world)
    self.go_position_setter = go_position_setter.new()
end

---@param e Entity
---@diagnostic disable-next-line: unused-local
function Entities:on_entity_removed(e)
end

---@param e Entity
---@diagnostic disable-next-line: unused-local
function Entities:on_entity_added(e)
end

---@return Entity
function Entities:create_player(position)
    ---@class Entity
    local e = {}
    e.player = { idx = 1 }
    ---@type PlayerGo2d
    e.player_go = nil
    e.position = vmath.vector3(position.x, position.y, 0)
    e.look_at = ENUMS.DIRECTION.LEFT

    e.movement = {
		input = vmath.vector3(0, 0, 0),
		velocity = vmath.vector3(0, 0, 0),
		direction = vmath.vector3(0, 0, 0),
		max_speed = BALANCE.config.player_speed,
		max_speed_limit = 1, --[0,1] for virtual pad to make movement more easy  
		accel = 8 * 0.016,
		deaccel = 15 * 0.016,
		deaccel_stop = 0.5,
	}
    e.moving = false
    e.dynamic_z = {
        dz = 0
    }

    return e
end


return Entities
