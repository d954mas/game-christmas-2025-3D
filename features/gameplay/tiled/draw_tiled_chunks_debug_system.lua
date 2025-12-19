local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local BALANCE = require "game.balance"
local LUME = require "libs.lume"
local CONSTANTS = require "libs.constants"
local TILED_FEATURE = require "features.gameplay.tiled.tiled_levels_feature"
local TILED_CHUNKS = require "features.gameplay.tiled.tiled_chunks"

local COLOR_CHUNK = vmath.vector4(0, 1, 0, 1)
local COLOR_TILE = vmath.vector4(0, 0.6, 1, 0.35)

---@class DrawTiledChunksDebugSystem:EcsSystem
local System = CLASS.class("DrawTiledChunksDebugSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

function System:draw(_)
	if not CONSTANTS.VERSION_IS_DEV then
		return
	end
	if not (TILED_FEATURE.storage and TILED_FEATURE.storage:is_draw_debug_tile_layers()) then
		return
	end
	local level = self.world.game_world.level_creator.level
	if not level then
		return
	end

	local tile_size = BALANCE.config.tile_size
	local map_w = level.data.size.w
	local map_h = level.data.size.h
	local width = map_w * tile_size
	local height = map_h * tile_size

	for x = 0, map_w do
		local px = x * tile_size
		LUME.draw_line(px, 0, 0, px, height, 0, COLOR_TILE)
	end
	for y = 0, map_h do
		local py = y * tile_size
		LUME.draw_line(0, py, 0, width, py, 0, COLOR_TILE)
	end

	TILED_CHUNKS.iterate(map_w, map_h, function (x1, y1, x2, y2)
		local left = x1 * tile_size
		local right = (x2 + 1) * tile_size
		local bottom = y1 * tile_size
		local top = (y2 + 1) * tile_size

		LUME.draw_line(left, bottom, 0, right, bottom, 0, COLOR_CHUNK)
		LUME.draw_line(right, bottom, 0, right, top, 0, COLOR_CHUNK)
		LUME.draw_line(right, top, 0, left, top, 0, COLOR_CHUNK)
		LUME.draw_line(left, top, 0, left, bottom, 0, COLOR_CHUNK)
	end)
end

return System
