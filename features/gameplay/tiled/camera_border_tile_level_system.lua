local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local CAMERAS = require "features.core.camera.cameras_feature"
local BALANCE = require "game.balance"
local LUME = require "libs.lume"

local TEMP_V = vmath.vector3(0)
local VIEW_AREA = vmath.vector3(0)

---@class CameraBordersSystem:EcsSystem
local System = CLASS.class("CameraBordersSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

function System:initialize()
	ECS.System.initialize(self)
	self.borders = { x1 = 0, x2 = 0, y1 = 0, y2 = 0 }
	self.screen_size = { w = 0, h = 0 }
end

function System:check_borders()
	local level = self.world.game_world.level_creator.level
	local cam = CAMERAS.current_camera
	self.w = level.data.size.w * BALANCE.config.tile_size
	self.h = level.data.size.h * BALANCE.config.tile_size
	cam:get_view_area_to_vector3(VIEW_AREA)
	self.borders.x1 = 0 + VIEW_AREA.x / 2
	self.borders.x2 = level.data.size.w * BALANCE.config.tile_size - VIEW_AREA.x / 2
	self.borders.y1 = 0 + VIEW_AREA.y / 2
	self.borders.y2 = level.data.size.h * BALANCE.config.tile_size - VIEW_AREA.y / 2
end

function System:update(_)
	self:check_borders()
	--check if camera view bigger then level
	local cam = CAMERAS.current_camera
	local oldX, oldY, z = cam:get_position_raw()
	TEMP_V.x = LUME.clamp(oldX, self.borders.x1, self.borders.x2)
	TEMP_V.y = LUME.clamp(oldY, self.borders.y1, self.borders.y2)
	TEMP_V.z = z
	cam:get_view_area_to_vector3(VIEW_AREA)
	if VIEW_AREA.x >= self.w then
		TEMP_V.x = self.borders.x1 + self.w / 2 - VIEW_AREA.x / 2
	elseif VIEW_AREA.y >= self.h then
		TEMP_V.y = self.borders.y1 + self.h / 2 - VIEW_AREA.y / 2
	end
	cam:set_position(TEMP_V)
end

return System
