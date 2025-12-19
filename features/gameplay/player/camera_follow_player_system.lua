local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local CAMERAS = require "features.core.camera.cameras_feature"
local BALANCE = require "game.balance"
local STORAGE = require "features.core.storage.storage"
local SmoothDumpV3 = require "features.core.smoothdump.smooth_dump_v3"
local SmoothDump = require "features.core.smoothdump.smooth_dump"

local TEMP_V = vmath.vector3(0)
local TEMP_V2 = vmath.vector3(0)
local CAM_POS_V = vmath.vector3(0)
local VIEW_AREA_NO_ZOOM = vmath.vector3(0)

---@class CameraFollowPlayerSystem:EcsSystem
local System = CLASS.class("CameraFollowPlayerSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

function System:initialize()
	ECS.System.initialize(self)
	self.velocity = vmath.vector3()
	self.smooth_dump = SmoothDumpV3.new()
	self.smooth_dump.maxDistance = 120
	self.smooth_dump.smoothTime = 0.33
	self.smooth_dump_zoom = SmoothDump.new()
	self.smooth_dump_zoom.maxDelta = 0.001
	self.smooth_dump_zoom.smoothTime = 0.1
	self.album = CAMERAS.current_camera == CAMERAS.CAMERAS.GAME_2D_ALBUM
end

function System:camera_one_player(dt)
	CAMERAS.current_camera:set_ortho_scale(STORAGE.cameras_storage:get_zoom())
	local speed = self.world.game_world.level_creator.player.move_speed
	self.smooth_dump.maxSpeed = speed - 5

	local world = self.world.game_world
	local player = world.level_creator.player

	TEMP_V.x, TEMP_V.y = player.body:GetPositionRawScaled(BALANCE.config.physics_scale)
	TEMP_V.z = 0

	TEMP_V.y = TEMP_V.y + BALANCE.config.camera_dy

    CAMERAS.current_camera:get_position_to_vector3(CAM_POS_V)
	self.smooth_dump:update(CAM_POS_V, TEMP_V, dt)

	CAMERAS.current_camera:set_position(CAM_POS_V)
end

function System:camera_two_player(dt)
	local p1 = self.world.game_world.level_creator.players[1]
	local p2 = self.world.game_world.level_creator.players[2]
	local speed = p1.move_speed
	self.smooth_dump.maxSpeed = speed - 5

	TEMP_V.x, TEMP_V.y = p1.body:GetPositionRawScaled(BALANCE.config.physics_scale)
	TEMP_V.y = TEMP_V.y - 20
	TEMP_V.z = 0

	TEMP_V2.x, TEMP_V2.y = p2.body:GetPositionRawScaled(BALANCE.config.physics_scale)
	TEMP_V2.y = TEMP_V2.y - 20
	TEMP_V2.z = 0

	local level = self.world.game_world.level_creator.level
	local max_w = level.data.size.w * BALANCE.config.tile_size
	local max_h = level.data.size.h * BALANCE.config.tile_size
	local player_w = math.min(math.max(math.abs(TEMP_V.x - TEMP_V2.x) + 250, 0), max_w)
	local player_h = math.min(math.max(math.abs(TEMP_V.y - TEMP_V2.y) + 250, 0), max_h)


	CAMERAS.current_camera:get_view_area_no_zoom_to_vector3(VIEW_AREA_NO_ZOOM)
	local w = player_w / VIEW_AREA_NO_ZOOM.x
	local h = player_h / VIEW_AREA_NO_ZOOM.y

	local target_zoom = 1 / math.max(w, h)

	if target_zoom > 1 then
		target_zoom = 1
	end

	local zoom = self.smooth_dump_zoom:update(CAMERAS.current_camera:get_ortho_scale(), target_zoom, dt)

	CAMERAS.current_camera:set_ortho_scale(zoom)


	xmath.sub(TEMP_V2, TEMP_V2, TEMP_V)
	xmath.mul(TEMP_V2, TEMP_V2, 0.5)
	xmath.add(TEMP_V, TEMP_V, TEMP_V2)


	TEMP_V.y = TEMP_V.y + BALANCE.config.camera_dy
    CAMERAS.current_camera:get_position_to_vector3(CAM_POS_V)
	self.smooth_dump:update(CAM_POS_V, TEMP_V, dt)
	CAMERAS.current_camera:set_position(CAM_POS_V)
end

function System:update(dt)
	local album = RENDER.screen_size.aspect >= 1
	if album ~= self.album then
		self.album = album
		local new_camera = album and CAMERAS.CAMERAS.GAME_2D_ALBUM or CAMERAS.CAMERAS.GAME_2D_PORTRAIT
		new_camera:set_position_raw(CAMERAS.current_camera:get_position_raw())
		CAMERAS.current_camera = new_camera
	end

	local players = self.world.game_world.level_creator.players
	if #players == 1 then
		self:camera_one_player(dt)
	else
		self:camera_two_player(dt)
	end
end

return System
