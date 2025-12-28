local ENUMS = require "game.enums"

local DEFAULT_SCALE = 2

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
        collisions[i] = { root = HASH_URL_ROOT, collision = hash("collisionobject_" .. i), shapes = {} }
    end
    COLLISIONS_GO_CONVEX_CONFIGS_COLLISIONS[shapes_num] = collisions
    return collisions
end



local M = {
    OBJECTS = {
        BENCH = {
            skins = {
                {
                    id = "base", type = ENUMS.OBJECT_TYPE.OBJECT,
                    factory = msg.url("game_scene:/_kenney_holiday_kit/root#bench"),
                    models = MODELS, collisions = get_collision_config(2),
                    phong = vmath.vector4(2, 0.1, 0, 0), scale = DEFAULT_SCALE,
                },
                {
                    id = "short", type = ENUMS.OBJECT_TYPE.OBJECT,
                    factory = msg.url("game_scene:/_kenney_holiday_kit/root#bench-short"),
                    models = MODELS, collisions = get_collision_config(2),
                    phong = vmath.vector4(2, 0.1, 0, 0), scale = DEFAULT_SCALE,
                },
            }
        },
        CORNER = {
            type = ENUMS.OBJECT_TYPE.OBJECT,
            skins = {
                {
                    id = "default",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-corner"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "bottom",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-corner-bottom"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "logs",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-corner-logs"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                }
            },
        },
        FENCE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-fence"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        DOOR = {
            skins = {
                {
                    id = "door",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-door-rotate"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "doorway_center",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-doorway-center"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "doorway_left",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-doorway-left"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "doorway_right",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-doorway-right"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "doorway",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-doorway"),
                    models = MODELS, collisions = get_collision_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "overhang_door",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-overhang-door-rotate"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "overhang_doorway",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-overhang-doorway"),
                    models = MODELS, collisions = get_collision_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
                }
            }
        },
        ROOF = {
            skins = {
                {
                    id = "chimney",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-chimney"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "corner",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-corner"),
                    models = MODELS, collisions = get_collision_convex_config(9), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "dormer",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-dormer"),
                    models = MODELS, collisions = get_collision_config(5), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "point",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-point"),
                    models = MODELS, collisions = get_collision_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "snow_chimney",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow-chimney"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "snow_corner",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow-corner"),
                    models = MODELS, collisions = get_collision_convex_config(9), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "snow_dormer",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow-dormer"),
                    models = MODELS, collisions = get_collision_config(5), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "snow_point",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow-point"),
                    models = MODELS, collisions = get_collision_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "snow",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-snow"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "top",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof-top"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "roof",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-roof"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        WALL = {
            skins = {
                {
                    id = "default",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "low",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall-low"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "roof_center",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall-roof-center"),
                    models = MODELS, collisions = get_collision_convex_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "roof",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall-roof"),
                    models = MODELS, collisions = get_collision_convex_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "wreath",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-wall-wreath"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        WINDOW = {
            skins = {
                {
                    id = "a",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-window-a"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "b",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-window-b"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "c",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-window-c"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "large",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#cabin-window-large"),
                    models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        CANDY_CANE = {
            skins = {
                {
                    id = "green",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#candy-cane-green"),
                    models = MODELS, collisions = get_collision_convex_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "red",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#candy-cane-red"),
                    models = MODELS, collisions = get_collision_convex_config(3), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        FESTIVUS_POLE = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#festivus-pole"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        FLOOR = {
            skins = {
                {
                    id = "stone",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#floor-stone"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "wood_snow",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#floor-wood-snow"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "wood",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#floor-wood"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            },
        },
        GINGERBREAD = {
            skins = {
                {
                    id = "man",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#gingerbread-man"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "woman",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#gingerbread-woman"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        HANUKKAH = {
            skins = {
                {
                    id = "dreidel",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#hanukkah-dreidel"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "menorah_candles",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#hanukkah-menorah-candles"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "menorah",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#hanukkah-menorah"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        KWANZAA = {
            skins = {
                {
                    id = "kinara_alternative",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#kwanzaa-kinara-alternative"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "kinara",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#kwanzaa-kinara"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "kikombe",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#kwanzaa-kikombe"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        LANTERN = {
            skins = {
                {
                    id = "default",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lantern"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "hanging",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lantern-hanging"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        LIGHTS = {
            skins = {
                {
                    id = "colored",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lights-colored"),
                    models = MODELS, collisions = {}, phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "green",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lights-green"),
                    models = MODELS, collisions = {}, phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "red",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#lights-red"),
                    models = MODELS, collisions = {}, phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        NUTCRACKER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#nutcracker"),
            models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        PRESENT = {
            skins = {
                {
                    id = "a_cube",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-a-cube"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "a_rectangle",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-a-rectangle"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "a_round",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-a-round"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "b_cube",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-b-cube"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "b_rectangle",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-b-rectangle"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "b_round",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#present-b-round"),
                    models = MODELS, collisions = get_collision_config(1), phong = vmath.vector4(2, 0.1, 0, 0),
                },
            }
        },
        REINDEER = {
            type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#reindeer"),
            models = MODELS, collisions = get_collision_config(2), phong = vmath.vector4(2, 0.1, 0, 0),
        },
        ROCKS = {
            skins = {
                {
                    id = "large",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#rocks-large"),
                    models = MODELS, collisions = get_collision_convex_config(27), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "medium",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#rocks-medium"),
                    models = MODELS, collisions = get_collision_convex_config(15), phong = vmath.vector4(2, 0.1, 0, 0),
                },
                {
                    id = "small",
                    type = ENUMS.OBJECT_TYPE.OBJECT, factory = msg.url("game_scene:/_kenney_holiday_kit/root#rocks-small"),
                    models = MODELS, collisions = get_collision_convex_config(15), phong = vmath.vector4(2, 0.1, 0, 0),
                }
            }
        },
    }
}

for _, object in pairs(M.OBJECTS) do
    if object.skins then
        for i = 1, #object.skins do
            local skin = object.skins[i]
            if skin.scale == nil then
                skin.scale = DEFAULT_SCALE
            end
        end
    elseif object.scale == nil then
        object.scale = DEFAULT_SCALE
    end
end





return M
