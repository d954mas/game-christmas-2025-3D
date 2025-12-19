local LEVELS = require "features.gameplay.tiled.levels.levels"
local CAMERAS = require "features.core.camera.cameras_feature"
local CLASS = require "libs.class"
local CONSTANTS = require "libs.constants"
local BALANCE = require "game.balance"
local DynamicZ = require "features.core.dynamic_z"

---@class LevelCreator
local Creator = CLASS.class("LevelCreator")

function Creator.new(game_world)
	return CLASS.new_instance(Creator, game_world)
end

---@param game_world GameWorld
function Creator:initialize(game_world)
	self.game_world = game_world
	self.ecs = game_world.ecs
	self.entities = self.ecs.entities
end

function Creator:load_level(name)
	self.level = LEVELS.load_level(name)
	self.dynamic_z = DynamicZ.new(0, self.level.data.size.h * BALANCE.config.tile_size,
		BALANCE.config.z_order.TILE_MAP_Z1, BALANCE.config.z_order.TILE_MAP_Z2)
	--game.pathfinding_init_map(self.level.data.size.w, self.level.data.size.h)
	self.layers = {

	}
	self:__create_geometry()
	self:__create_player()
	self:__create_tiles()
	self:__create_game_objects()
	self:__create_visual_objects()

end

function Creator:__create_geometry()
	local box2d_world = self.game_world.box2d_world
	local physics_scale = BALANCE.config.physics_scale

	local tiles_to_meters = 2; --1 tile is 2 meters

	---@type Box2dBodyDef
	local body_def = {
		type = box2d.b2BodyType.b2_staticBody,
		position = vmath.vector3(0)
	}
	---@type Box2dFixtureDef
	local fixture_def = {
		filter = {
			categoryBits = box2d_world.groups.GEOMETRY,
			maskBits = box2d_world.masks.GEOMETRY,
			groupIndex = 0,
		},
		friction = 2,
		density = 2,
		shape = box2d.NewPolygonShape()
	}

	local fixture_def_chain = {
		filter = {
			categoryBits = box2d_world.groups.GEOMETRY,
			maskBits = box2d_world.masks.GEOMETRY,
			groupIndex = 0,
		},
		friction = 2,
		density = 2,
	}

	local x1, y1 = 0, 0
	local x2, y2 = self.level.data.size.w * tiles_to_meters, self.level.data.size.h * tiles_to_meters
	local cx = (x2 - x1) / 2
	local cy = (y2 - y1) / 2
	local w = x2 - x1
	local h = y2 - y1

	local border_size = 1

	--create base borders
	--bottom
	body_def.position = vmath.vector3(cx, y1 - border_size / 2, 0)
	fixture_def.shape:SetAsBox(w / 2, border_size / 2)
	local body = box2d_world.world:CreateBody(body_def)
	body:CreateFixture(fixture_def)



	--top
	body_def.position = vmath.vector3(cx, y2 + border_size / 2, 0)
	fixture_def.shape:SetAsBox(w / 2, border_size / 2)
	body = box2d_world.world:CreateBody(body_def)
	body:CreateFixture(fixture_def)

	--left
	body_def.position = vmath.vector3(x1 - border_size / 2, cy, 0)
	fixture_def.shape:SetAsBox(border_size / 2, h / 2)
	body = box2d_world.world:CreateBody(body_def)
	body:CreateFixture(fixture_def)

	--right
	body_def.position = vmath.vector3(x2 + border_size / 2, cy, 0)
	fixture_def.shape:SetAsBox(border_size / 2, h / 2)
	body = box2d_world.world:CreateBody(body_def)
	body:CreateFixture(fixture_def)

	for _, obj in ipairs(self.level.data.geometry) do
		obj.x = obj.x * tiles_to_meters
		obj.y = obj.y * tiles_to_meters
		obj.w = obj.w * tiles_to_meters
		obj.h = obj.h * tiles_to_meters
		if (obj.radius) then
			obj.radius = obj.radius * tiles_to_meters
		end
		if (obj.shape == "rectangle") then
			body_def.position = vmath.vector3((obj.x + obj.w / 2) * physics_scale, (obj.y - obj.h / 2) * physics_scale, 0)
			fixture_def.shape = box2d.NewPolygonShape()
			fixture_def.shape:SetAsBox(obj.w / 2 * physics_scale, obj.h / 2 * physics_scale)
			body = box2d_world.world:CreateBody(body_def)
			body:CreateFixture(fixture_def)
		elseif (obj.shape == "circle") then
			body_def.position = vmath.vector3(obj.x * physics_scale, obj.y * physics_scale, 0)
			fixture_def.shape = box2d.NewCircleShape()
			fixture_def.shape:SetRadius(obj.radius * physics_scale)
			body = box2d_world.world:CreateBody(body_def)
			body:CreateFixture(fixture_def)
		elseif (obj.shape == "polygon") then
			local vertices = {}
			local ox, oy = obj.x * physics_scale, obj.y * physics_scale
			if (obj.properties.reverse) then
				for i = #obj.vertices, 1, -1 do
					local v = obj.vertices[i]
					table.insert(vertices, vmath.vector3(v[1] * physics_scale, v[2] * physics_scale, 0))
				end
			else
				for _, v in ipairs(obj.vertices) do
					table.insert(vertices, vmath.vector3(v[1] * physics_scale, v[2] * physics_scale, 0))
				end
			end

			body_def.position = vmath.vector3(ox, oy, 0)
			fixture_def_chain.shape = box2d.NewChainShape()
			fixture_def_chain.shape:CreateLoop(vertices)

			body = box2d_world.world:CreateBody(body_def)
			body:CreateFixture(fixture_def_chain)
		end
	end
end

function Creator:__create_player()
	self.players = {}
	self.player = self.entities:create_player(vmath.vector3(self.level.data.player.center_x, self.level.data.player.y, 0))
	self.players[1] = self.player
	CAMERAS.current_camera:set_position(vmath.vector3(self.player.position.x, self.player.position.y
		+ BALANCE.config.camera_dy, 0))
	self.ecs:add_entity(self.player)
end

function Creator:__create_tiles_layer(data, z)
	return {
		tiles = assert(data),
		z = assert(z)
	}
end

function Creator:__create_game_objects()
	for _, obj in ipairs(self.level.data.game_objects) do
	end
end

function Creator:__create_visual_objects()
	for _, obj in ipairs(self.level.data.visual_object) do
		if (obj.properties.type == "object_visual") then
			self.ecs:add_entity(self.entities:create_visual_object(self.level, obj))
		else
			pprint(obj)
			error("unknown object:" .. tostring(obj.properties.type))
		end
	end
end

function Creator:__create_tiles()
	self.layers.ground = self:__create_tiles_layer(self.level.data.ground, CONSTANTS.Z_ORDER.TILE_GROUND)
	self.layers.front = self:__create_tiles_layer(self.level.data.front, CONSTANTS.Z_ORDER.TILE_FRONT)
end

return Creator
