local ACTIONS = require "libs.actions.actions"
local ANALYTICS = require "features.sdk.analytics.analytics"

local Box2dWorld = require "features.core.box2d.box2d_world"
local LevelCreator = require "features.gameplay.tiled.level_creator_tiled"
local GameEcs = require "game.ecs.game_ecs_3d"

---@class GameWorld2D
local GameWorld = {}

function GameWorld:init()
    self.game_actions = ACTIONS.Parallel.new(false)
    self.game_actions.drop_empty = false
    self.ecs = GameEcs.new(self)
    self:reset_state()
end

function GameWorld:game_loaded(level)
    assert(not self.box2d_world)
    self:reset_state()
    self.box2d_world = Box2dWorld.new({ gravity = vmath.vector3(0),
        velocity_iterations = 2, position_iterations = 2,
        time_step = 1 / 60 }, self)
    self.ecs:add_systems()
    self.level_creator = LevelCreator.new(self)
    self.level_creator:load_level(level)

    ANALYTICS:level_loaded(level)
end

function GameWorld:reset_state()
     self.state = {
        time = 0,
        first_move = false,
        can_show_ads = false
    }
end

function GameWorld:fixed_update(dt)
    self.state.time = self.state.time + dt
    self.ecs:fixed_update(dt)
end

function GameWorld:update(dt)
    self.game_actions:update(dt)
    self.ecs.ecs:draw(dt)
end

function GameWorld:final()
    self.ecs:clear()
end

GameWorld:init()

return GameWorld
