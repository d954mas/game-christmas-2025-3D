local CLASS = require "libs.class"
local Entities = require "game.ecs.entities"
local ECS = require "libs.ecs"

local AutoDestroySystem = require "game.ecs.systems.auto_destroy_system"

local CameraTiledLevelBordersSystem = require "features.gameplay.tiled.camera_border_tile_level_system"
local CameraFollowPlayerSystem = require "features.gameplay.player.camera_follow_player_system"
local PlayerMoveBox2dSystem = require "features.core.box2d.player_move_box2d_system"
local PlayerInputSystem = require "features.gameplay.player.player_movement2d_input_system"

local DrawVisualObjectSystem = require "features.gameplay.tiled.draw_visual_objects_tiled_system"

local GoPositionSetterUpdateSystem = require "features.core.go_position_setter.update_go_position_setter"
local Box2dUpdatePositionSystem = require "features.core.box2d.box2d_update_position"
local Box2dUpdateSystem = require "features.core.box2d.box2d_update_system"
local Draw2dPlayerSystem = require "features.gameplay.player.draw_2d_player_system"
local DrawTileLayerSystem = require "features.gameplay.tiled.draw_tile_layer_system"

--#IF DEBUG
local DrawBox2dDebugSystem = require "features.core.box2d.draw_box2d_debug_system"
local DrawTiledChunksDebugSystem = require "features.gameplay.tiled.draw_tiled_chunks_debug_system"
--#ENDIF

---@class GameEcsWorld
local EcsWorld = CLASS.class("EcsWorld")

function EcsWorld.new(game_world) return CLASS.new_instance(EcsWorld, game_world) end

---@param game_world GameWorld
function EcsWorld:initialize(game_world)
	self.game_world = assert(game_world)

	---@class EcsWorld
	self.ecs = ECS.world()
	self.ecs.game_world = game_world

	self.entities = Entities.new(game_world)

	---@diagnostic disable-next-line: duplicate-set-field
	self.ecs.on_entity_added = function (_, e) self.entities:on_entity_added(e) end
	---@diagnostic disable-next-line: duplicate-set-field
	self.ecs.on_entity_removed = function (_, e) self.entities:on_entity_removed(e) end

	self.performance = {
		time = { current = 0, max = 0, average = 0, average_count = 0, average_value = 0 }
	}
end

function EcsWorld:add_systems()
	--#IF DEBUG

	--#ENDIF

	self.ecs:add_system(PlayerInputSystem.new())
	self.ecs:add_system(PlayerMoveBox2dSystem.new())
	self.ecs:add_system(CameraFollowPlayerSystem.new())
	self.ecs:add_system(CameraTiledLevelBordersSystem.new())

	self.ecs:add_system(Box2dUpdateSystem.new())
	self.ecs:add_system(Box2dUpdatePositionSystem.new())
	self.ecs:add_system(GoPositionSetterUpdateSystem.new())

	self.ecs:add_system(DrawVisualObjectSystem.new())
	self.ecs:add_system(Draw2dPlayerSystem.new())
	self.ecs:add_system(DrawTileLayerSystem.new())
	--#IF DEBUG
	self.ecs:add_system(DrawBox2dDebugSystem.new())
	self.ecs:add_system(DrawTiledChunksDebugSystem.new())
	--#ENDIF

	--can remove or add new entities. So it should be last
	self.ecs:add_system(AutoDestroySystem.new())
end

function EcsWorld:fixed_update(dt)
	--if dt will be too big. It can create a lot of objects.
	--big dt can be in html when change page and then return
	--or when move game window in Windows.
	local max_dt = 0.1
	if (dt > max_dt) then dt = max_dt end

	--#IF DEBUG
	local time = chronos.nanotime()
	--#ENDIF

	self.ecs:update(dt)
	--remove entities in current frame
	self.ecs:refresh()

	--#IF DEBUG
	self.performance.time.current = chronos.nanotime() - time
	self.performance.time.max = math.max(self.performance.time.max, self.performance.time.current)
	self.performance.time.average = self.performance.time.average + self.performance.time.current
	self.performance.time.average_count = self.performance.time.average_count + 1
	--update once a 1 second
	if self.performance.time.average_count >= 60 then
		self.performance.time.average_value = self.performance.time.average / self.performance.time.average_count
		self.performance.time.max_value = self.performance.time.max
		self.performance.time.max = 0
		self.performance.time.average = 0
		self.performance.time.average_count = 0
	end
	--#ENDIF
end

function EcsWorld:clear()
	self.ecs:clear()
end

function EcsWorld:refresh()
	self.ecs:refresh()
end

function EcsWorld:add_entity(e)
	assert(e)
	self.ecs:add_entity(e)
end

function EcsWorld:remove_entity(e)
	assert(e)
	self.ecs:remove_entity(e)
end

return EcsWorld
