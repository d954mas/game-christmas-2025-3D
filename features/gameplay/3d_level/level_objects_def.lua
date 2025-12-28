local ENUMS = require "game.enums"
local KENNEY_HOLIDAY_KIT = require "features.gameplay.3d_level.objects.kenny_holiday_kit._kenney_holiday_kit_objects_def"
local M = {}

local MODEL = { root = hash("/model"), model = hash("model"), tint = vmath.vector4(1, 1, 1, 1) }
local MODELS = {
    MODEL
}

local HASH_URL_ROOT = hash("/root")

local COLLISIONS_GO_CONFIGS_COLLISIONS = {}
local function get_collision_config(shapes_num)
    if COLLISIONS_GO_CONFIGS_COLLISIONS[shapes_num] then
        return COLLISIONS_GO_CONFIGS_COLLISIONS[shapes_num]
    end
    local collisions = { root = HASH_URL_ROOT, collision = hash("collisionobject"), shapes = {} }
    for i = 1, shapes_num do
        collisions.shapes[i] =  hash("shape_" .. i)
    end
    COLLISIONS_GO_CONFIGS_COLLISIONS[shapes_num] = collisions
    return { collisions }
end



M.TYPES = {
    COMMON = {
        OBJECTS = {
            EMPTY = {
                type = ENUMS.OBJECT_TYPE.OBJECT,
                no_object_entity = true,
            },
            CUBE_1 = {
                type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/root#factory_common_cube_1"),
                models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                scale_type = ENUMS.SCALE_TYPE.ALL, scale_set_shape_size = true
            },
        },
    },
    PHYSICS = {
        OBJECTS = {
            CUBE = {
                type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/root#factory_common_physics_cube"),
                models = {}, collisions = get_collision_config(1)
            },
        },
    },
    KENNEY_HOLIDAY_KIT = KENNEY_HOLIDAY_KIT,
}




M.BY_ID = {}
M.OBJECTS_LIST = {}

for type_name, type in pairs(M.TYPES) do
    for id, v in pairs(type.OBJECTS) do
        v.id = type_name .. "_" .. id
        assert(not M.BY_ID[v.id], "object:" .. v.id .. " already exist")
        M.BY_ID[v.id] = v
        v.asset_pack = type_name
        table.insert(M.OBJECTS_LIST, v.id)
    end
end

table.sort(M.OBJECTS_LIST)




return M
