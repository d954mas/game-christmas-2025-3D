local ACTIONS = require "libs.actions.actions"
local ANALYTICS = require "features.sdk.analytics.analytics"
local HASHES = require "libs.hashes"

local GameEcs = require "game.ecs.game_ecs_3d"
local Lights = require "features.core.illumination.illumination"
local LevelCreator3d = require "features.gameplay.3d_level.level_creator"

---@class GameWorld3D
local GameWorld = {}

function GameWorld:init()
    self.game_actions = ACTIONS.Parallel.new(false)
    self.game_actions.drop_empty = false
    self.lights = Lights.new()
    self.ecs = GameEcs.new(self)
    self.level_creator = LevelCreator3d.new(self)
    self:reset_state()
end

function GameWorld:game_loaded(level)
    self:reset_state()
    self.ecs:add_systems()

    ANALYTICS:level_loaded(level)
end

function GameWorld:change_location(location_id)
    self.game_actions:clear()
    self.ecs:clear()
    self.ecs:refresh()
    self.ecs:add_systems()
    self.level_creator:create_location(location_id)
    self.level_creator:create_player(self.level_creator.location_data.data.spawn_position)
    ANALYTICS.location_loaded(self, location_id)
end

function GameWorld:reset_state()
    self.state = {
        time = 0,
        first_move = false,
        can_show_ads = false,
    }
end

function GameWorld:fixed_update(dt)
    self.state.time = self.state.time + dt
    self.ecs:fixed_update(dt)
end

function GameWorld:update(dt)
    self.game_actions:update(dt)
    self.ecs.ecs:draw(dt)

    local show_ads = self:can_show_ads()
    if self.state.can_show_ads ~= show_ads then
        self.state.can_show_ads = show_ads
        self.level_creator.location_data:trigger_location_changed()
    end
end

function GameWorld:can_show_ads()
    return false
end

function GameWorld:final()
    self.ecs:clear()
end

function GameWorld:teleport(obj, position, cb)
    assert(obj)
    msg.post(assert(obj.physics.collision), HASHES.DISABLE)
    timer.delay(2/60, false, function ()
        go.set(assert(obj.physics.collision), HASHES.PHYSICS.LINEAR_VELOCITY, vmath.vector3(0, 0, 0))
        go.set_position(position, assert(obj.physics.collision))
        msg.post(obj.physics.collision, HASHES.ENABLE)
        if cb then cb() end
    end)
end

GameWorld:init()

return GameWorld
