return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "left-down",
  width = 1,
  height = 1,
  tilewidth = 64,
  tileheight = 64,
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "objects",
      firstgid = 1,
      class = "",
      tilewidth = 878,
      tileheight = 591,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 92,
      tiles = {
        {
          id = 1,
          properties = {
            ["type"] = "player"
          },
          image = "objects/player.png",
          width = 80,
          height = 87
        },
        {
          id = 3,
          properties = {
            ["type"] = "apple_tree"
          },
          image = "objects/tree_apple.png",
          width = 133,
          height = 168
        },
        {
          id = 4,
          properties = {
            ["area_id"] = "fox_start_apples",
            ["helper_id"] = "FOX_APPLES_1",
            ["type"] = "fox"
          },
          image = "objects/fox.png",
          width = 72,
          height = 87
        },
        {
          id = 5,
          properties = {
            ["type"] = "blueberry_bush"
          },
          image = "objects/blueberry_bush.png",
          width = 81,
          height = 74
        },
        {
          id = 6,
          properties = {
            ["type"] = "cloudberry_bush"
          },
          image = "objects/cloudberry_bush.png",
          width = 64,
          height = 54
        },
        {
          id = 7,
          properties = {
            ["type"] = "hive_tree"
          },
          image = "objects/hive_tree.png",
          width = 115,
          height = 150
        },
        {
          id = 8,
          properties = {
            ["type"] = "mushroom_spot"
          },
          image = "objects/mushroom_spot.png",
          width = 34,
          height = 39
        },
        {
          id = 9,
          properties = {
            ["type"] = "real_blueberry_bush"
          },
          image = "objects/real_blueberry_bush.png",
          width = 69,
          height = 64
        },
        {
          id = 10,
          properties = {
            ["type"] = "beaver"
          },
          image = "objects/beaver.png",
          width = 151,
          height = 123
        },
        {
          id = 11,
          properties = {
            ["type"] = "elk"
          },
          image = "objects/elk.png",
          width = 417,
          height = 403
        },
        {
          id = 12,
          properties = {
            ["type"] = "panda"
          },
          image = "objects/panda.png",
          width = 201,
          height = 239
        },
        {
          id = 13,
          properties = {
            ["building_id"] = "REAL_BLUEBERRY_1",
            ["type"] = "building"
          },
          image = "objects/real_blueberry_bush_disabled.png",
          width = 69,
          height = 64
        },
        {
          id = 14,
          properties = {
            ["building_id"] = "TREE_1",
            ["type"] = "building"
          },
          image = "objects/tree_apple_disabled.png",
          width = 133,
          height = 168
        },
        {
          id = 15,
          properties = {
            ["type"] = "border"
          },
          image = "objects/border.png",
          width = 80,
          height = 80
        },
        {
          id = 16,
          properties = {
            ["type"] = "border_buy_zone"
          },
          image = "objects/border_buy_zone.png",
          width = 80,
          height = 80
        },
        {
          id = 17,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_1.png",
          width = 80,
          height = 80
        },
        {
          id = 18,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_1_hf.png",
          width = 80,
          height = 80
        },
        {
          id = 19,
          properties = {
            ["dy_z"] = 160,
            ["type"] = "border"
          },
          image = "objects/border_2.png",
          width = 80,
          height = 80
        },
        {
          id = 20,
          properties = {
            ["dy_z"] = 80,
            ["type"] = "border"
          },
          image = "objects/border_3.png",
          width = 80,
          height = 80
        },
        {
          id = 21,
          properties = {
            ["dy_z"] = 80,
            ["type"] = "border"
          },
          image = "objects/border_3_hf.png",
          width = 80,
          height = 80
        },
        {
          id = 22,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_4.png",
          width = 80,
          height = 80
        },
        {
          id = 23,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_5.png",
          width = 80,
          height = 80
        },
        {
          id = 24,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_5_hf.png",
          width = 80,
          height = 80
        },
        {
          id = 25,
          properties = {
            ["type"] = "cart"
          },
          image = "objects/cart.png",
          width = 68,
          height = 78
        },
        {
          id = 26,
          properties = {
            ["type"] = "moped"
          },
          image = "objects/moped.png",
          width = 90,
          height = 55
        },
        {
          id = 27,
          properties = {
            ["building_id"] = "BLUEBERRY_1",
            ["type"] = "building"
          },
          image = "objects/blueberry_bush_disabled.png",
          width = 81,
          height = 74
        },
        {
          id = 28,
          properties = {
            ["building_id"] = "CLOUDBERRY_1",
            ["type"] = "building"
          },
          image = "objects/cloudberry_bush_disabled.png",
          width = 64,
          height = 54
        },
        {
          id = 29,
          properties = {
            ["building_id"] = "HIVE_1",
            ["type"] = "building"
          },
          image = "objects/hive_tree_disabled.png",
          width = 115,
          height = 150
        },
        {
          id = 30,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_6.png",
          width = 80,
          height = 80
        },
        {
          id = 31,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_7.png",
          width = 80,
          height = 80
        },
        {
          id = 32,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_8.png",
          width = 80,
          height = 80
        },
        {
          id = 33,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_9.png",
          width = 80,
          height = 80
        },
        {
          id = 34,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_10.png",
          width = 80,
          height = 80
        },
        {
          id = 35,
          properties = {
            ["dy_z"] = 45,
            ["type"] = "border"
          },
          image = "objects/border_11.png",
          width = 80,
          height = 80
        },
        {
          id = 36,
          properties = {
            ["type"] = "teleport"
          },
          image = "objects/teleport_in.png",
          width = 105,
          height = 163
        },
        {
          id = 37,
          properties = {
            ["type"] = "pine_tree_1"
          },
          image = "objects/pine_1.png",
          width = 119,
          height = 167
        },
        {
          id = 38,
          properties = {
            ["type"] = "pine_tree_2"
          },
          image = "objects/pine_2.png",
          width = 114,
          height = 175
        },
        {
          id = 39,
          properties = {
            ["type"] = "pine_tree_3"
          },
          image = "objects/pine_3.png",
          width = 115,
          height = 175
        },
        {
          id = 40,
          properties = {
            ["building_id"] = "PINE_1_1",
            ["type"] = "building"
          },
          image = "objects/pine_1_disabled.png",
          width = 119,
          height = 167
        },
        {
          id = 41,
          properties = {
            ["building_id"] = "PINE_2_1",
            ["type"] = "building"
          },
          image = "objects/pine_2_disabled.png",
          width = 114,
          height = 175
        },
        {
          id = 42,
          properties = {
            ["building_id"] = "PINE_3_1",
            ["type"] = "building"
          },
          image = "objects/pine_3_disabled.png",
          width = 115,
          height = 175
        },
        {
          id = 43,
          properties = {
            ["type"] = "player_teleport"
          },
          image = "objects/player_teleport_pos.png",
          width = 80,
          height = 87
        },
        {
          id = 44,
          properties = {
            ["chest_id"] = "CHEST_1",
            ["type"] = "chest"
          },
          image = "objects/chest.png",
          width = 144,
          height = 129
        },
        {
          id = 45,
          properties = {
            ["type"] = "owl"
          },
          image = "objects/owl.png",
          width = 102,
          height = 111
        },
        {
          id = 47,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_1",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_1.png",
          width = 79,
          height = 71
        },
        {
          id = 48,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_2",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_2.png",
          width = 79,
          height = 71
        },
        {
          id = 49,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_3",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_3.png",
          width = 79,
          height = 71
        },
        {
          id = 50,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_4",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_4.png",
          width = 79,
          height = 71
        },
        {
          id = 51,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_5",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_5.png",
          width = 79,
          height = 71
        },
        {
          id = 52,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_6",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_6.png",
          width = 79,
          height = 71
        },
        {
          id = 53,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_7",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_7.png",
          width = 79,
          height = 71
        },
        {
          id = 54,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_8",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_8.png",
          width = 79,
          height = 71
        },
        {
          id = 55,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_9",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_9.png",
          width = 79,
          height = 71
        },
        {
          id = 56,
          properties = {
            ["blueprint_id"] = "BLUEPRINT_10",
            ["type"] = "blueprint"
          },
          image = "objects/blueprint_10.png",
          width = 79,
          height = 71
        },
        {
          id = 57,
          properties = {
            ["type"] = "plane"
          },
          image = "objects/plane.png",
          width = 342,
          height = 252
        },
        {
          id = 58,
          properties = {
            ["type"] = "wood_converter"
          },
          image = "objects/wood_converter.png",
          width = 260,
          height = 146
        },
        {
          id = 59,
          properties = {
            ["resource_object_id"] = "TREE_1",
            ["type"] = "resource_object"
          },
          image = "objects_visual/tree_2.png",
          width = 175,
          height = 201
        },
        {
          id = 61,
          properties = {
            ["resource_object_id"] = "STONE_1",
            ["type"] = "resource_object"
          },
          image = "objects/stone.png",
          width = 88,
          height = 61
        },
        {
          id = 62,
          properties = {
            ["building_id"] = "WOOD_CONVERTER_1",
            ["type"] = "building"
          },
          image = "objects/building_wood_converter.png",
          width = 109,
          height = 99
        },
        {
          id = 63,
          properties = {
            ["building_id"] = "STONE_CONVERTER_1",
            ["type"] = "building"
          },
          image = "objects/building_stone_converter.png",
          width = 288,
          height = 285
        },
        {
          id = 64,
          properties = {
            ["building_id"] = "BANK_1",
            ["type"] = "building"
          },
          image = "objects/building_bank.png",
          width = 109,
          height = 99
        },
        {
          id = 65,
          properties = {
            ["building_id"] = "QUEST_1",
            ["type"] = "building"
          },
          image = "objects/building_quest.png",
          width = 109,
          height = 99
        },
        {
          id = 66,
          properties = {
            ["building_id"] = "QUEST_1",
            ["type"] = "building"
          },
          image = "objects/quest_castle.png",
          width = 227,
          height = 280
        },
        {
          id = 67,
          properties = {
            ["building_id"] = "BLACKSMITH_AXE",
            ["type"] = "building"
          },
          image = "objects/blacksmith_axe.png",
          width = 233,
          height = 280
        },
        {
          id = 68,
          properties = {
            ["resource_object_id"] = "IRON_ORE_1",
            ["type"] = "resource_object"
          },
          image = "objects/iron_ore.png",
          width = 120,
          height = 120
        },
        {
          id = 69,
          properties = {
            ["building_id"] = "COW_BUILDING_1",
            ["type"] = "building"
          },
          image = "objects/cow_building.png",
          width = 298,
          height = 341
        },
        {
          id = 70,
          properties = {
            ["building_id"] = "IRON_CONVERTER_1",
            ["type"] = "building"
          },
          image = "objects/building_iron_converter.png",
          width = 234,
          height = 262
        },
        {
          id = 71,
          properties = {
            ["building_id"] = "BLACKSMITH_PICKAXE",
            ["type"] = "building"
          },
          image = "objects/blacksmith_pickaxe.png",
          width = 233,
          height = 280
        },
        {
          id = 72,
          properties = {
            ["resource_object_id"] = "CRYSTAL_ORE_1",
            ["type"] = "resource_object"
          },
          image = "objects/crystal_ore_1.png",
          width = 114,
          height = 120
        },
        {
          id = 73,
          properties = {
            ["building_id"] = "DRAGON_1",
            ["type"] = "building"
          },
          image = "objects/dragon.png",
          width = 282,
          height = 290
        },
        {
          id = 74,
          properties = {
            ["building_id"] = "LIGHTHOUSE_1",
            ["type"] = "building"
          },
          image = "objects/lightgouse.png",
          width = 205,
          height = 367
        },
        {
          id = 75,
          properties = {
            ["type"] = "cloud"
          },
          image = "objects/cloud_1.png",
          width = 617,
          height = 471
        },
        {
          id = 76,
          properties = {
            ["type"] = "cloud"
          },
          image = "objects/cloud_2.png",
          width = 603,
          height = 458
        },
        {
          id = 77,
          properties = {
            ["type"] = "cloud"
          },
          image = "objects/cloud_3.png",
          width = 878,
          height = 591
        },
        {
          id = 78,
          properties = {
            ["type"] = "cloud"
          },
          image = "objects/cloud_4.png",
          width = 864,
          height = 577
        },
        {
          id = 79,
          properties = {
            ["ads_type"] = "GOLD_AXE",
            ["type"] = "ads"
          },
          image = "objects/interact_zone_ads.png",
          width = 128,
          height = 216
        },
        {
          id = 80,
          properties = {
            ["ads_type"] = "GOLD_PICKAXE",
            ["type"] = "ads"
          },
          image = "objects/interact_zone_ads.png",
          width = 128,
          height = 216
        },
        {
          id = 81,
          properties = {
            ["building_id"] = "CANNON_1",
            ["type"] = "building"
          },
          image = "objects/cannon_1.png",
          width = 226,
          height = 230
        },
        {
          id = 82,
          properties = {
            ["building_id"] = "BASE_CASTLE_1",
            ["type"] = "building"
          },
          image = "objects/base_castle.png",
          width = 114,
          height = 140
        },
        {
          id = 83,
          properties = {
            ["resource_object_id"] = "TREE_CAT_1",
            ["type"] = "resource_object"
          },
          image = "objects/tree_wood_cat.png",
          width = 106,
          height = 217
        },
        {
          id = 84,
          properties = {
            ["building_id"] = "BUTCHER_CONVERTER_1",
            ["type"] = "building"
          },
          image = "objects/butcher.png",
          width = 173,
          height = 171
        },
        {
          id = 85,
          properties = {
            ["building_id"] = "BLACKSMITH_SWORD",
            ["type"] = "building"
          },
          image = "objects/blacksmith_cat.png",
          width = 156,
          height = 189
        },
        {
          id = 86,
          properties = {
            ["building_id"] = "CANNON_CAT_1",
            ["type"] = "building"
          },
          image = "objects/cannon_building.png",
          width = 100,
          height = 125
        },
        {
          id = 87,
          properties = {
            ["building_id"] = "BARRELS_BUILDING_1",
            ["type"] = "building"
          },
          image = "objects/barrels_building.png",
          width = 150,
          height = 168
        },
        {
          id = 88,
          properties = {
            ["building_id"] = "FIRE_1",
            ["type"] = "building"
          },
          image = "objects/fire.png",
          width = 48,
          height = 48
        },
        {
          id = 89,
          properties = {
            ["building_id"] = "STONE_BREAKER_1",
            ["type"] = "building"
          },
          image = "objects/stone_breaker.png",
          width = 193,
          height = 165
        },
        {
          id = 90,
          properties = {
            ["building_id"] = "HOT_DOG_1",
            ["type"] = "building"
          },
          image = "objects/hot_dog_producer.png",
          width = 138,
          height = 180
        },
        {
          id = 91,
          properties = {
            ["ads_type"] = "GOLD_SWORD",
            ["type"] = "ads"
          },
          image = "objects/interact_zone_ads.png",
          width = 128,
          height = 216
        },
        {
          id = 92,
          properties = {
            ["area_id"] = "lumberjack_1",
            ["helper_id"] = "LUMBERJACK_1",
            ["type"] = "lumberjack"
          },
          image = "objects/lumberjack.png",
          width = 117,
          height = 121
        },
        {
          id = 93,
          properties = {
            ["building_id"] = "CAT_2_BUILDING_1",
            ["type"] = "building"
          },
          image = "objects/cat_2_building.png",
          width = 142,
          height = 191
        },
        {
          id = 94,
          properties = {
            ["building_id"] = "STONE_BRICK_1",
            ["type"] = "building"
          },
          image = "objects/stone_brick_building.png",
          width = 189,
          height = 221
        },
        {
          id = 95,
          properties = {
            ["ads_type"] = "BOOTS",
            ["type"] = "ads"
          },
          image = "objects/interact_zone_ads.png",
          width = 128,
          height = 216
        }
      }
    },
    {
      name = "ground",
      firstgid = 97,
      class = "",
      tilewidth = 80,
      tileheight = 80,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 9,
      tiles = {
        {
          id = 1,
          properties = {
            ["ground_id"] = "SAND"
          },
          image = "tiles/grass/grass_2.png",
          width = 80,
          height = 80
        },
        {
          id = 2,
          properties = {
            ["ground_id"] = "GRASS"
          },
          image = "tiles/grass/grass_1.png",
          width = 80,
          height = 80
        },
        {
          id = 3,
          properties = {
            ["ground_id"] = "SWAMP"
          },
          image = "tiles/swamp/swamp_1.png",
          width = 80,
          height = 80
        },
        {
          id = 4,
          properties = {
            ["ground_id"] = "WATER"
          },
          image = "tiles/water.png",
          width = 80,
          height = 80
        },
        {
          id = 5,
          properties = {
            ["ground_id"] = "GRASS_LONG"
          },
          image = "tiles/grass_long/grass_long_2.png",
          width = 80,
          height = 80
        },
        {
          id = 6,
          properties = {
            ["ground_id"] = "GRASS_LONG"
          },
          image = "tiles/grass_long/grass_long_2_1.png",
          width = 80,
          height = 80
        },
        {
          id = 7,
          properties = {
            ["ground_id"] = "GRASS_LONG"
          },
          image = "tiles/grass_long/grass_long_2_2.png",
          width = 80,
          height = 80
        },
        {
          id = 8,
          properties = {
            ["ground_id"] = "GRASS_LONG"
          },
          image = "tiles/grass_long/grass_long_2_3.png",
          width = 80,
          height = 80
        },
        {
          id = 9,
          properties = {
            ["ground_id"] = "GRASS_LONG"
          },
          image = "tiles/grass_long/grass_long_2_4.png",
          width = 80,
          height = 80
        }
      }
    },
    {
      name = "roads",
      firstgid = 107,
      class = "",
      tilewidth = 40,
      tileheight = 40,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 2,
      tiles = {
        {
          id = 1,
          image = "tiles/road_1.png",
          width = 40,
          height = 40
        },
        {
          id = 2,
          image = "tiles/road_2.png",
          width = 40,
          height = 40
        }
      }
    },
    {
      name = "front",
      firstgid = 110,
      class = "",
      tilewidth = 80,
      tileheight = 80,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 21,
      tiles = {
        {
          id = 4,
          image = "tiles/grass/grass_3.png",
          width = 80,
          height = 80
        },
        {
          id = 5,
          image = "tiles/grass/grass_4.png",
          width = 80,
          height = 80
        },
        {
          id = 6,
          image = "tiles/grass/grass_5.png",
          width = 80,
          height = 80
        },
        {
          id = 7,
          image = "tiles/grass/grass_6.png",
          width = 80,
          height = 80
        },
        {
          id = 8,
          image = "tiles/grass/grass_7.png",
          width = 80,
          height = 80
        },
        {
          id = 9,
          image = "tiles/grass/grass_8.png",
          width = 80,
          height = 80
        },
        {
          id = 10,
          image = "tiles/grass/grass_9.png",
          width = 80,
          height = 80
        },
        {
          id = 21,
          image = "tiles/swamp/swamp_3.png",
          width = 80,
          height = 80
        },
        {
          id = 22,
          image = "tiles/swamp/swamp_4.png",
          width = 80,
          height = 80
        },
        {
          id = 23,
          image = "tiles/swamp/swamp_5.png",
          width = 80,
          height = 80
        },
        {
          id = 24,
          image = "tiles/swamp/swamp_6.png",
          width = 80,
          height = 80
        },
        {
          id = 25,
          image = "tiles/swamp/swamp_7.png",
          width = 80,
          height = 80
        },
        {
          id = 26,
          image = "tiles/swamp/swamp_8.png",
          width = 80,
          height = 80
        },
        {
          id = 27,
          image = "tiles/swamp/swamp_9.png",
          width = 80,
          height = 80
        },
        {
          id = 28,
          image = "tiles/grass_long/grass_long_3.png",
          width = 80,
          height = 80
        },
        {
          id = 29,
          image = "tiles/grass_long/grass_long_4.png",
          width = 80,
          height = 80
        },
        {
          id = 30,
          image = "tiles/grass_long/grass_long_5.png",
          width = 80,
          height = 80
        },
        {
          id = 31,
          image = "tiles/grass_long/grass_long_6.png",
          width = 80,
          height = 80
        },
        {
          id = 32,
          image = "tiles/grass_long/grass_long_7.png",
          width = 80,
          height = 80
        },
        {
          id = 33,
          image = "tiles/grass_long/grass_long_8.png",
          width = 80,
          height = 80
        },
        {
          id = 34,
          image = "tiles/grass_long/grass_long_9.png",
          width = 80,
          height = 80
        }
      }
    },
    {
      name = "objects visual",
      firstgid = 145,
      class = "",
      tilewidth = 184,
      tileheight = 201,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 64,
      tiles = {
        {
          id = 5,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_1.png",
          width = 80,
          height = 80
        },
        {
          id = 6,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_2.png",
          width = 80,
          height = 80
        },
        {
          id = 7,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_3.png",
          width = 80,
          height = 80
        },
        {
          id = 8,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_4.png",
          width = 80,
          height = 80
        },
        {
          id = 9,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_5.png",
          width = 80,
          height = 80
        },
        {
          id = 10,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_6.png",
          width = 80,
          height = 80
        },
        {
          id = 11,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_7.png",
          width = 80,
          height = 80
        },
        {
          id = 12,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_8.png",
          width = 80,
          height = 80
        },
        {
          id = 13,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_9.png",
          width = 80,
          height = 80
        },
        {
          id = 14,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/grass_top_10.png",
          width = 80,
          height = 80
        },
        {
          id = 26,
          properties = {
            ["dynamic_z"] = true,
            ["factory"] = "object_visual_bush_2",
            ["type"] = "object_visual"
          },
          image = "objects_visual/bush_2.png",
          width = 56,
          height = 53
        },
        {
          id = 27,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/swamp_top_1.png",
          width = 80,
          height = 80
        },
        {
          id = 28,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/swamp_top_2.png",
          width = 80,
          height = 80
        },
        {
          id = 29,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/swamp_top_3.png",
          width = 80,
          height = 80
        },
        {
          id = 30,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 15,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/swamp_top_4.png",
          width = 80,
          height = 68
        },
        {
          id = 31,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/swamp_top_5.png",
          width = 81,
          height = 81
        },
        {
          id = 32,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/swamp_top_6.png",
          width = 80,
          height = 80
        },
        {
          id = 33,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/swamp_top_7.png",
          width = 80,
          height = 80
        },
        {
          id = 34,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":16,\n      \"position\":{\n         \"x\":0,\n         \"y\":16\n      }\n   }\n}",
            ["dynamic_z"] = true,
            ["factory"] = "object_visual_willow_tree_2",
            ["type"] = "object_visual"
          },
          image = "objects_visual/willow_tree_2.png",
          width = 115,
          height = 150
        },
        {
          id = 35,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":16,\n      \"position\":{\n         \"x\":0,\n         \"y\":16\n      }\n   }\n}",
            ["dynamic_z"] = true,
            ["factory"] = "object_visual_willow_tree",
            ["type"] = "object_visual"
          },
          image = "objects_visual/willow_tree.png",
          width = 126,
          height = 155
        },
        {
          id = 36,
          properties = {
            ["dynamic_z"] = true,
            ["factory"] = "object_visual_reed",
            ["type"] = "object_visual"
          },
          image = "objects_visual/reed.png",
          width = 80,
          height = 80
        },
        {
          id = 37,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":16,\n      \"position\":{\n         \"x\":0,\n         \"y\":16\n      }\n   }\n}",
            ["dynamic_z"] = true,
            ["factory"] = "object_visual_tree_2",
            ["type"] = "object_visual"
          },
          image = "objects_visual/tree_2.png",
          width = 175,
          height = 201
        },
        {
          id = 38,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = "25",
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/dandelions.png",
          width = 92,
          height = 72
        },
        {
          id = 39,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/flower_meadow _2.png",
          width = 79,
          height = 47
        },
        {
          id = 40,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/flower_meadow.png",
          width = 152,
          height = 79
        },
        {
          id = 41,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"RECT\",\n      \"hx\":40,\n      \"hy\":18,\n      \"angle\":0,\n      \"position\":{\n         \"x\":0,\n         \"y\":31\n      }\n   }\n}",
            ["b2_round_corners"] = 16,
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = "10",
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/hay.png",
          width = 90,
          height = 63
        },
        {
          id = 42,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"RECT\",\n      \"hx\":34,\n      \"hy\":15,\n      \"angle\":0,\n      \"position\":{\n         \"x\":0,\n         \"y\":26\n      }\n   }\n}",
            ["b2_round_corners"] = 10,
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/log.png",
          width = 83,
          height = 53
        },
        {
          id = 43,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"RECT\",\n      \"hx\":32,\n      \"hy\":13,\n      \"angle\":25,\n      \"position\":{\n         \"x\":0,\n         \"y\":32\n      }\n   }\n}",
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/log_2.png",
          width = 71,
          height = 62
        },
        {
          id = 44,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"RECT\",\n      \"hx\":54,\n      \"hy\":30,\n      \"angle\":0,\n      \"position\":{\n         \"x\":-6,\n         \"y\":40\n      }\n   }\n}",
            ["b2_round_corners"] = 28,
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 8,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/logs.png",
          width = 115,
          height = 78
        },
        {
          id = 45,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/n_bush.png",
          width = 71,
          height = 66
        },
        {
          id = 46,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/n_bush_2.png",
          width = 32,
          height = 38
        },
        {
          id = 47,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/spots.png",
          width = 139,
          height = 67
        },
        {
          id = 48,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/spots_2.png",
          width = 154,
          height = 93
        },
        {
          id = 49,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/spots_3.png",
          width = 184,
          height = 98
        },
        {
          id = 50,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/stone.png",
          width = 56,
          height = 49
        },
        {
          id = 51,
          properties = {
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/stones.png",
          width = 126,
          height = 79
        },
        {
          id = 52,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":25,\n      \"position\":{\n         \"x\":0,\n         \"y\":30\n      }\n   }\n}",
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 10,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/stones_2.png",
          width = 89,
          height = 74
        },
        {
          id = 53,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"RECT\",\n      \"hx\":35,\n      \"hy\":52,\n      \"angle\":65,\n      \"position\":{\n         \"x\":0,\n         \"y\":52\n      }\n   }\n}",
            ["b2_round_corners"] = 20,
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 25,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/stones_3.png",
          width = 184,
          height = 110
        },
        {
          id = 54,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":20,\n      \"position\":{\n         \"x\":0,\n         \"y\":22\n      }\n   }\n}",
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/stump.png",
          width = 65,
          height = 56
        },
        {
          id = 55,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":16,\n      \"position\":{\n         \"x\":8,\n         \"y\":16\n      }\n   }\n}",
            ["dynamic_z"] = true,
            ["factory"] = "object_visual_bamboo_1",
            ["type"] = "object_visual"
          },
          image = "objects_visual/bamboo_1.png",
          width = 158,
          height = 145
        },
        {
          id = 56,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":16,\n      \"position\":{\n         \"x\":4,\n         \"y\":6\n      }\n   }\n}",
            ["dynamic_z"] = true,
            ["factory"] = "object_visual_bamboo_2",
            ["type"] = "object_visual"
          },
          image = "objects_visual/bamboo_2.png",
          width = 131,
          height = 173
        },
        {
          id = 57,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":16,\n      \"position\":{\n         \"x\":0,\n         \"y\":16\n      }\n   }\n}",
            ["b2_round_corners"] = 16,
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/bamboo_stone_1.png",
          width = 41,
          height = 36
        },
        {
          id = 59,
          properties = {
            ["b2BodyType"] = "b2_staticBody",
            ["b2FixedRotation"] = true,
            ["b2_fixture_def"] = "{\n   \"filter\":{\n      \"categoryBits\":\"OBSTACLES\",\n      \"maskBits\":\"OBSTACLES\",\n      \"groupIndex\":0\n   },\n   \"friction\":0,\n   \"density\":4,\n   \"restitution\":0,\n   \"shape\":{\n      \"type\":\"CIRCLE\",\n      \"radius\":36,\n      \"position\":{\n         \"x\":0,\n         \"y\":32\n      }\n   }\n}",
            ["b2_round_corners"] = 16,
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 6,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/bamboo_stone_3.png",
          width = 88,
          height = 73
        },
        {
          id = 60,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 5,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_1.png",
          width = 93,
          height = 87
        },
        {
          id = 61,
          properties = {
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_2.png",
          width = 41,
          height = 56
        },
        {
          id = 62,
          properties = {
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_3.png",
          width = 52,
          height = 76
        },
        {
          id = 63,
          properties = {
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_4.png",
          width = 35,
          height = 59
        },
        {
          id = 64,
          properties = {
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_5.png",
          width = 80,
          height = 88
        },
        {
          id = 65,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 5,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_6.png",
          width = 35,
          height = 59
        },
        {
          id = 66,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 5,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_7.png",
          width = 45,
          height = 66
        },
        {
          id = 67,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 5,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_8.png",
          width = 52,
          height = 58
        },
        {
          id = 68,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 5,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_9.png",
          width = 42,
          height = 43
        },
        {
          id = 69,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 10,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_10.png",
          width = 112,
          height = 94
        },
        {
          id = 70,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 8,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_11.png",
          width = 87,
          height = 78
        },
        {
          id = 71,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 5,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_12.png",
          width = 65,
          height = 62
        },
        {
          id = 72,
          properties = {
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_13.png",
          width = 76,
          height = 66
        },
        {
          id = 73,
          properties = {
            ["dynamic_z"] = true,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_14.png",
          width = 79,
          height = 50
        },
        {
          id = 74,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 3,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_15.png",
          width = 49,
          height = 61
        },
        {
          id = 75,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 3,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_16.png",
          width = 69,
          height = 62
        },
        {
          id = 76,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 8,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_17.png",
          width = 89,
          height = 80
        },
        {
          id = 77,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 3,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_18.png",
          width = 84,
          height = 61
        },
        {
          id = 78,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 4,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_19.png",
          width = 84,
          height = 61
        },
        {
          id = 79,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 3,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_20.png",
          width = 57,
          height = 59
        },
        {
          id = 80,
          properties = {
            ["dynamic_z"] = true,
            ["dynamic_z_dy"] = 5,
            ["factory"] = "object_visual",
            ["type"] = "object_visual"
          },
          image = "objects_visual/plant_21.png",
          width = 57,
          height = 87
        }
      }
    },
    {
      name = "pathfinding",
      firstgid = 226,
      class = "",
      tilewidth = 80,
      tileheight = 80,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 1,
      tiles = {
        {
          id = 1,
          image = "pathfinding/blocked.png",
          width = 80,
          height = 80
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 1,
      height = 1,
      id = 1,
      name = "layer",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0
      }
    }
  }
}
