local ENUMS = require "game.enums"

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



local M = {
    OBJECTS = {
        BENCH_SHORT = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#bench-short"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        BENCH = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#bench"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_CORNER_BOTTOM = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-corner-bottom"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_CORNER_LOGS = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-corner-logs"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_CORNER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-corner"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_DOOR_ROTATE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-door-rotate"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_DOORWAY_CENTER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-doorway-center"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_DOORWAY_LEFT = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-doorway-left"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_DOORWAY_RIGHT = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-doorway-right"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_DOORWAY = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-doorway"),
            models = MODELS, collisions = get_collision_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_FENCE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-fence"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_OVERHANG_DOOR_ROTATE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-overhang-door-rotate"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_OVERHANG_DOORWAY = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-overhang-doorway"),
            models = MODELS, collisions = get_collision_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_CHIMNEY = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-chimney"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_CORNER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-corner"),
            models = MODELS, collisions = get_collision_convex_config(9), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_DORMER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-dormer"),
            models = MODELS, collisions = get_collision_config(5), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_POINT = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-point"),
            models = MODELS, collisions = get_collision_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_SNOW_CHIMNEY = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow-chimney"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_SNOW_CORNER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow-corner"),
            models = MODELS, collisions = get_collision_convex_config(9), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_SNOW_DORMER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow-dormer"),
            models = MODELS, collisions = get_collision_config(5), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_SNOW_POINT = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow-point"),
            models = MODELS, collisions = get_collision_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_SNOW = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF_TOP = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-top"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_ROOF = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WALL_LOW = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall-low"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WALL_ROOF_CENTER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall-roof-center"),
            models = MODELS, collisions = get_collision_convex_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WALL_ROOF = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall-roof"),
            models = MODELS, collisions = get_collision_convex_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WALL_WREATH = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall-wreath"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WALL = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WINDOW_A = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-window-a"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WINDOW_B = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-window-b"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WINDOW_C = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-window-c"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CABIN_WINDOW_LARGE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-window-large"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CANDY_CANE_GREEN = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#candy-cane-green"),
            models = MODELS, collisions = get_collision_convex_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        CANDY_CANE_RED = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#candy-cane-red"),
            models = MODELS, collisions = get_collision_convex_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        FESTIVUS_POLE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#festivus-pole"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        FLOOR_STONE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#floor-stone"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        FLOOR_WOOD_SNOW = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#floor-wood-snow"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        FLOOR_WOOD = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#floor-wood"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        GINGERBREAD_MAN = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#gingerbread-man"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        GINGERBREAD_WOMAN = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#gingerbread-woman"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        HANUKKAH_DREIDEL = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#hanukkah-dreidel"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        HANUKKAH_MENORAH_CANDLES = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#hanukkah-menorah-candles"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        HANUKKAH_MENORAH = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#hanukkah-menorah"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        KWANZAA_KIKOMBE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#kwanzaa-kikombe"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        KWANZAA_KINARA_ALTERNATIVE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#kwanzaa-kinara-alternative"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        KWANZAA_KINARA = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#kwanzaa-kinara"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        LANTERN_HANGING = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lantern-hanging"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        LANTERN = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lantern"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        LIGHTS_COLORED = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lights-colored"),
            models = MODELS, collisions = {}, phong = vmath.vector4(2, 0.1, 0, 0),
        },
        LIGHTS_GREEN = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lights-green"),
            models = MODELS, collisions = {}, phong = vmath.vector4(2, 0.1, 0, 0),
        },
        LIGHTS_RED = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lights-red"),
            models = MODELS, collisions = {}, phong = vmath.vector4(2, 0.1, 0, 0),
        },
        NUTCRACKER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#nutcracker"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        PRESENT_A_CUBE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-a-cube"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        PRESENT_A_RECTANGLE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-a-rectangle"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        PRESENT_A_ROUND = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-a-round"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        PRESENT_B_CUBE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-b-cube"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        PRESENT_B_RECTANGLE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-b-rectangle"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        PRESENT_B_ROUND = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-b-round"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        REINDEER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#reindeer"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        ROCKS_LARGE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#rocks-large"),
            models = MODELS, collisions = get_collision_convex_config(27), phong = vmath.vector4(2, 0.1, 0, 0),
        },
    }
}





return M
