local ACTIONS = require "libs.actions.actions"
local GameEcs = require "game.ecs.game_ecs"

---@class GameWorld
local GameWorld = {}

function GameWorld:init()
    self.game_actions = ACTIONS.Parallel.new(false)
    self.game_actions.drop_empty = false
    self.ecs = GameEcs.new(self)
    self.ecs:add_systems()
    self.ecs:fixed_update(1)
    self:reset_state()
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
