local CLASS = require "libs.class"
local ENUMS = require "game.enums"
local PLAYER_SKINS_3D_FEATURE = require "features.meta.skins.player_skin3d_feature"
local LUME = require "libs.lume"
local SmoothDumpV3 = require "features.core.smoothdump.smooth_dump_v3"

local FACTORY_URL_PLAYER = msg.url("game_scene:/root#factory_player")
local FACTORY_URL_ROOT_EMPTY = msg.url("game_scene:/root#factory_root_empty")

local PARTS = {
	ROOT = hash("/root"),
	COLLISION = hash("/collision"),
	PARTICLES = hash("/particles"),
}

---@class Entity
---@field auto_destroy_delay number
---@field auto_destroy bool
---@field body Box2dBody
---@field level_map_object LevelMapObject
---@field tile_data LevelMapTile
---@field look_at string


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
	e.player = true
	e.position = vmath.vector3(position)
	e.look_dir = vmath.vector3(0, 0, -1)
	e.skin = PLAYER_SKINS_3D_FEATURE.storage:get_skin()
	---@type Entity|nil
	e.current_interact_aabb = nil
	---@type Entity|nil
	e.current_interact_aabb_look = nil
	e.camera = {
		distance = {
			last_value = 20,
			value = 20, min = 10, max = 30,
			min_album = 20, max_album = 40
		},
		first_view = false,
		angle_x = { value = -0.86, min = -0.86, max = -0.86 },
		angle_y = { value = 0, min = 0, max = 0 },

		position = vmath.vector3(),
		rotation = vmath.quat_rotation_z(0),
		rotation_euler = vmath.vector3(),
		rotation_billboard_gui = vmath.quat_rotation_z(0), --it use some fixes because with rotation (0,90,0) or (0,-90,0) font is super blurry
	}

	xmath.normalize(e.camera.look_dir, e.camera.look_dir)

	local urls_physics = collectionfactory.create(FACTORY_URL_PLAYER, e.position)
	local urls_empty = collectionfactory.create(FACTORY_URL_ROOT_EMPTY, e.position)
	e.player_go = {
		physics = {
			root = msg.url(assert(urls_physics[PARTS.ROOT])),
			collision = nil,
		},
		root = msg.url(assert(urls_empty[PARTS.ROOT])),
		model = {
			root = nil,
			model = nil,
			mesh_root = nil,
			mesh_origin = nil
		},
		hat = {
			root = nil,
		},
		hand_item = {
			root = nil,
		},
		config = {
			skin = nil,
			hand_item = nil,
			animation = nil,
			look_dir = vmath.vector3(0, 0, -1),
			look_dir_smooth_dump = SmoothDumpV3.new(0.05),
		},
	}
	e.player_go.physics.collision = LUME.url_component_from_url(e.player_go.physics.root, "collision")

	e.movement = {
		input = vmath.vector3(0, 0, 0),
		velocity = vmath.vector3(0, 0, 0),
		direction = vmath.vector3(0, 0, 0),
		max_speed = 10,
		max_speed_limit = 1, --[0,1] for virtual pad to make movement more easy
		accel = 8 * 0.016,
		deaccel = 15 * 0.016,
		deaccel_stop = 0.5,
		strafe_power = 1,
		pressed_jump = false,
		physics_reset_y_velocity = 0
	}
	e.moving = false
	e.physics_linear_velocity = vmath.vector3()
	e.physics_object = game.new_physics_object(e.player_go.physics.root, e.player_go.physics.collision, e.position,
		e.physics_linear_velocity)

	e.grounded = {
		on_ground = false,
		normal = vmath.vector3(0, 1, 0),
		on_ground_time = 0,
		collision_hash = nil
	}
	e.jump = {
		last_time = -1,
		in_jump = true,
		power = 15000,
		idx = 0, -- for double jump
		max_jumps = 1,
	}

	e.position_setter_root = e.player_go.root

	return e
end


return Entities
