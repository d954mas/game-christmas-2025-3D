local ENUMS = require "game.enums"
local M = {}

local MODEL = { root = hash("/model"), model = hash("model"), tint = vmath.vector4(1, 1, 1, 1) }
local MODELS = {
    MODEL
}

local HASH_URL_ROOT = hash("/root")
local HASH_URL_COLLISION = hash("/collision")

local COLLISIONS_GO_CONFIGS_COLLISIONS = {}
local function get_collision_config(shapes_num)
    if COLLISIONS_GO_CONFIGS_COLLISIONS[shapes_num] then
        return COLLISIONS_GO_CONFIGS_COLLISIONS[shapes_num]
    end
    local collisions = { root = HASH_URL_ROOT, collision = hash("collisionobject"), shapes = {} }
    for i = 1, shapes_num do
        collisions.shapes[i] = hash("shape_" .. i)
    end
    local result = { collisions }
    COLLISIONS_GO_CONFIGS_COLLISIONS[shapes_num] = result
    return result
end

local COLLISIONS_GO_CONVEX_CONFIGS_COLLISIONS = {}
local function get_collision_convex_config(shapes_num)
    if COLLISIONS_GO_CONVEX_CONFIGS_COLLISIONS[shapes_num] then
        return COLLISIONS_GO_CONVEX_CONFIGS_COLLISIONS[shapes_num]
    end
    local collisions = {}
    for i = 1, shapes_num do
        collisions[i] = {
            { root = HASH_URL_COLLISION, collision = hash("collisionobject_" .. i), shapes = {} }
        }
    end
    COLLISIONS_GO_CONVEX_CONFIGS_COLLISIONS[shapes_num] = collisions
    return collisions
end



local OBJECTS = {
    BENCH = {
        type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#bench"),
        models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
    },
    --ADD MORE OBJECTS HERE
    ROCKS_LARGE = {
        type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#rocks-large"),
        models = MODELS, collisions = get_collision_convex_config(27), phong = vmath.vector4(2, 0.1, 0, 0),
    },
}





return OBJECTS
