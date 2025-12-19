local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local ENUMS = require "game.enums"
local LUME = require "libs.lume"

local FACTORY = msg.url("game_scene:/root#factory_player")

local TEMP_V = vmath.vector3(0)
local TEMP_Q = vmath.quat_rotation_z(0)


local PARTS = {
    ROOT = hash("/root"),
    BODY = hash("/body"),
    SPRITE_COMP = hash("sprite"),
}

---@class DrawPlayerSystem:EcsSystem
local System = CLASS.class("DrawPlayerSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

System.filter = ECS.filter("player")

function System:initialize()
    ECS.System.initialize(self)
end

---@param e Entity
function System:create_player_go(e)
    local factory_url = FACTORY
    local collection = collectionfactory.create(factory_url, e.position, nil, nil)
    ---@class PlayerGoView
    local player_view = {
        root = msg.url(assert(collection[PARTS.ROOT])),
        body = {
            root = msg.url(collection[PARTS.BODY]),
            sprite = nil
        },
    }
    player_view.body.sprite = LUME.url_component_from_url(player_view.body.root, PARTS.SPRITE_COMP)
    return player_view
end

---@param e Entity
function System:on_add(e)
    ---@class PlayerGo2d
    local player_go = {
        ---@type PlayerGoView
        view = self:create_player_go(e),
        config = {
            animation_time = 0,
            look_at = ENUMS.DIRECTION.LEFT,
        },
    }
    e.player_go = player_go
    self.world.game_world.ecs.entities.go_position_setter:add(player_go.view.root, e.position)
end

---@param e Entity
function System:get_animation(e)
    if (e.moving) then return ENUMS.PLAYER_ANIMATIONS_2D.RUN end
    return ENUMS.PLAYER_ANIMATIONS_2D.IDLE
end

---@param e Entity
function System:update_walk_animation(e, dt)
    local player = e.player_go.view
    local speed = e.moving and 22 or 6
    e.player_go.config.animation_time = e.player_go.config.animation_time + dt * speed

    local t = e.player_go.config.animation_time
    local bounce = math.sin(t) * (e.moving and 0.06 or 0.02)
    local squash = math.cos(t * 2) * (e.moving and 0.03 or 0.01)

    TEMP_V.x = 1 + squash
    TEMP_V.y = 1 + bounce
    TEMP_V.z = 1
    go.set_scale(TEMP_V, player.body.root)

    if e.player_go.config.look_at == ENUMS.DIRECTION.RIGHT then
        go.set(player.root, "scale.x", -1)
    else
        go.set(player.root, "scale.x", 1)
    end

    local lean = 0
    if e.moving then
        lean = math.cos(t * 0.45) * 0.12
    end
    xmath.quat_rotation_z(TEMP_Q, lean)
    go.set_rotation(TEMP_Q, player.body.root)
end

function System:update(dt)
    local entities = self.entities_list
    for i = 1, #entities do
        local player = entities[i]

        if player.player_go.config.look_at ~= player.look_at then
            player.player_go.config.look_at = player.look_at
            go.set(player.player_go.view.root, "scale.x", player.player_go.config.look_at == ENUMS.DIRECTION.RIGHT and -1 or 1)
        end
      --  go.set_position(player.position, player.player_go.view.root)
        self:update_walk_animation(player, dt)
    end
end

return System
