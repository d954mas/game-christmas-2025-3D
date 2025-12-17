local ACTIONS = require "libs.actions.actions"

---@class GameWorld
local GameWorld = {}

function GameWorld:init()
    self.state = {
        time = 0,
        first_move = false,
        can_show_ads = false
    }
    self.game_actions = ACTIONS.Parallel.new(false)
    self.game_actions.drop_empty = false
end

function GameWorld:fixed_update(dt)
    self.state.time = self.state.time + dt
    --self.ecs:fixed_update(dt)
end

function GameWorld:update(dt)
    self.game_actions:update(dt)
   -- self.ecs.ecs:draw(dt)
end

function GameWorld:final()
  --  self.ecs:clear()
end

GameWorld:init()

return GameWorld
