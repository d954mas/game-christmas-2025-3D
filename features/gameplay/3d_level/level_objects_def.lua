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
        collisions.shapes[i] = hash("shape_" .. i)
    end
    COLLISIONS_GO_CONFIGS_COLLISIONS[shapes_num] = collisions
    return { collisions }
end



M.TYPES = {
    COMMON = {
        order_priority = 1,
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
        order_priority = 1,
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
M.ALL_OBJECTS_LIST = {}

for type_name, type in pairs(M.TYPES) do
    for id, v in pairs(type.OBJECTS) do
        v.id = type_name .. "_" .. id
        assert(not M.BY_ID[v.id], "object:" .. v.id .. " already exist")
        M.BY_ID[v.id] = v
        v.asset_pack = type_name
        table.insert(M.ALL_OBJECTS_LIST, v.id)
        --if not skins use default
        if not v.skins then
            v.skins = {
                {
                    id = "default",
                    type = v.type, factory = v.factory,
                    models = v.models, collisions = v.collisions, phong = v.phong,
                }
            }
            v.type = nil
            v.factory = nil
            v.models = nil
            v.collisions = nil
            v.phong = nil
        end
        v.skins_by_id = {}
        for i = 1, #v.skins do
            local skin = v.skins[i]
            v.skins_by_id[skin.id] = skin
        end
    end
end
table.sort(M.ALL_OBJECTS_LIST)

M.TYPES_ORDER = {}
for k, _ in pairs(M.TYPES) do
    table.insert(M.TYPES_ORDER, k)
end


table.sort(M.TYPES_ORDER, function (a, b)
    local order_a = M.TYPES[a].order_priority or 0
    local order_b = M.TYPES[b].order_priority or 0
    if order_a == order_b then
        return a < b
    end
    return order_a > order_b
end)
pprint(M.TYPES_ORDER)
table.insert(M.TYPES_ORDER, 1, "ALL")


M.TYPES_LIST = {}
M.TYPES_LIST["ALL"] = M.ALL_OBJECTS_LIST
for k, v in pairs(M.TYPES) do
    local result = {}
    for k, v in pairs(v.OBJECTS) do
        table.insert(result, v.id)
    end
    M.TYPES_LIST[k] = result
end

return M
