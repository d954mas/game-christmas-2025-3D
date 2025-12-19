local CLASS = require "libs.class"
local ENUMS = require "game.enums"
local BALANCE = require "game.balance"

---@class Entity
---@field auto_destroy_delay number
---@field auto_destroy bool


local Entities = CLASS.class("Entities")

function Entities.new(game_world) return CLASS.new_instance(Entities, game_world) end

---@param game_world GameWorld
function Entities:initialize(game_world)
    self.game_world = assert(game_world)
end

---@param e Entity
---@diagnostic disable-next-line: unused-local
function Entities:on_entity_removed(e)
end

---@param e Entity
---@diagnostic disable-next-line: unused-local
function Entities:on_entity_added(e)
end

---@return Entity
function Entities:create_player(position)
    ---@class Entity
    local e = {}
    e.player = { idx = 1 }
    ---@type PlayerGo2d
    e.player_go = nil
    e.position = vmath.vector3(position.x, position.y, 0)
    e.direction = vmath.vector3(1, 0, 0)
    e.look_at = ENUMS.DIRECTION.LEFT

    e.move_speed = BALANCE.config.player_speed
    e.movement_max_speed_limit = 1 --[0,1] for virtual pad interpolation
    e.moving = false
    e.dynamic_z = {
        dz = 0
    }

    local box2d_world = self.game_world.box2d_world
    local physics_scale = BALANCE.config.physics_scale
    ---@type Box2dBodyDef
    local body_def = {
        type = box2d.b2BodyType.b2_dynamicBody,
        fixedRotation = true,
        position = vmath.vector3(e.position.x * physics_scale, e.position.y * physics_scale, 0)
    }
    local body = box2d_world.world:CreateBody(body_def)
    body:SetSleepingAllowed(false)
    body:SetUserData(e)
    e.body = body


    ---#region player interactive fixture
    ---@type Box2dFixtureDef
    local fixture_def_interact = {
        filter = {
            categoryBits = box2d_world.groups.PLAYER,
            maskBits = box2d_world.masks.PLAYER,
            groupIndex = 0,
        },
        friction = 0,
        density = 4,
        restitution = 0,
        isSensor = true
    }

    local shape = box2d.NewCircleShape()
    fixture_def_interact.shape = shape
    shape:SetRadius(16 * physics_scale)
    shape:SetPosition(vmath.vector3(0, 12, 0) * physics_scale)
    body:CreateFixture(fixture_def_interact)
    ---#endregion

    ---#region player collision.
    ---@type Box2dFixtureDef
    local fixture_def_collision = {
        filter = {
            categoryBits = box2d_world.groups.OBSTACLES,
            maskBits = box2d_world.masks.OBSTACLES,
            groupIndex = 0,
        },
        friction = 0,
        density = 4,
        restitution = 0,
    }

    shape = box2d.NewCircleShape()
    fixture_def_collision.shape = shape
    shape:SetRadius(6 * physics_scale)
    shape:SetPosition(vmath.vector3(0, 6, 0) * physics_scale)
    body:CreateFixture(fixture_def_collision)
    ---#endregion

    return e
end

---@param level Level
---@param object LevelMapObject
function Entities:create_visual_object(level, object)
    ---@class Entity
    local e = {}
    e.visual_object = true
    e.visual_object_go = nil
    e.level_map_object = object
    e.tile_data = level:get_tile(object.tile_id)

    local z = BALANCE.config.z_order.VISUAL_OBJECT
    if (object.properties.dynamic_z) then
        local y = object.y
        if (object.properties.dynamic_z_dy) then
            y = y + object.properties.dynamic_z_dy
        end
        z = self.game_world.level_creator.dynamic_z:count_z_pos(y)
    end

    e.position = vmath.vector3(object.center_x, object.y, z)

    if object.properties.b2BodyType then
        e.body = self:create_body(object)
    end

    return e
end

function Entities:create_physics(physics, fixture_def, body)
    local physics_scale = BALANCE.config.physics_scale
    for _, shape_cfg in pairs(physics.shapes) do
        if shape_cfg.type == "CIRCLE" then
            local shape = box2d.NewCircleShape()
            fixture_def.shape = shape
            shape:SetRadius(shape_cfg.radius * physics_scale)
            if shape_cfg.position then
                shape:SetPosition(vmath.vector3(
                    shape_cfg.position.x * physics_scale, shape_cfg.position.y * physics_scale, 0))
            end
        elseif shape_cfg.type == "RECT" then
            fixture_def.shape = box2d.NewPolygonShape()
            if shape_cfg.round_corners then
                local bot_left = vmath.vector3(shape_cfg.position.x - shape_cfg.w / 2,
                    shape_cfg.position.y - shape_cfg.h / 2, 0)
                local top_right = vmath.vector3(shape_cfg.position.x + shape_cfg.w / 2,
                    shape_cfg.position.y + shape_cfg.h / 2, 0)
                local corner = shape_cfg.round_corners
                local positions = {
                    vmath.vector3(bot_left.x + corner, top_right.y, 0),
                    vmath.vector3(bot_left.x, top_right.y - corner, 0),
                    vmath.vector3(bot_left.x, bot_left.y + corner, 0),
                    vmath.vector3(bot_left.x + corner, bot_left.y, 0),

                    vmath.vector3(top_right.x - corner, bot_left.y, 0),
                    vmath.vector3(top_right.x, bot_left.y + corner, 0),
                    vmath.vector3(top_right.x, top_right.y - corner, 0),
                    vmath.vector3(top_right.x - corner, top_right.y, 0),
                }

                local angle_rad = shape_cfg.angle or 0
                local s = math.sin(angle_rad);
                local c = math.cos(angle_rad);

                for _, point in ipairs(positions) do
                    --translate back to origin
                    point.x = point.x - shape_cfg.position.x
                    point.y = point.y - shape_cfg.position.y

                    -- rotate point
                    local xnew = point.x * c - point.y * s;
                    local ynew = point.x * s + point.y * c;

                    -- translate point back. And use it in meters
                    point.x = (xnew + shape_cfg.position.x) * physics_scale
                    point.y = (ynew + shape_cfg.position.y) * physics_scale
                end
                fixture_def.shape:Set(positions)
            else
                local dpos = vmath.vector3(shape_cfg.position.x * physics_scale, shape_cfg.position.y * physics_scale, 0)
                fixture_def.shape:SetAsBox(shape_cfg.w / 2 * physics_scale, shape_cfg.h / 2 * physics_scale, dpos, shape_cfg.angle or 0)
            end
        elseif shape_cfg.type == "CHAIN_LOOP" then
            local shape = box2d.NewChainShape()
            fixture_def.shape = shape
            local points = {}
            for i = 1, #shape_cfg.points do
                local point = shape_cfg.flip and shape_cfg.points[#shape_cfg.points - i + 1] or shape_cfg.points[i]
                points[i] = vmath.vector3(point.x * physics_scale, point.y * physics_scale, 0)
            end
            shape:CreateLoop(points)
        else
            error("physics unknown shape:" .. tostring(shape_cfg.type))
        end
        return body:CreateFixture(fixture_def)
    end
end

return Entities
