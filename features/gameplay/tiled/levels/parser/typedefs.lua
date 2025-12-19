---@class TileProperties
---@field type string
---@field dynamic_z number
---@field factory string
---@field dy_z number
---@field dynamic_z_dy number
---@field b2BodyType string
---@field b2FixedRotation boolean
---@field b2_fixture_def string
---@field b2_round_corners number

---@class LevelMapTile
---@field properties TileProperties
---@field id number
---@field image string
---@field image_hash hash calculate when load tilesets


---@class LevelMapObject
---@field tile_id number
---@field properties TileProperties
---@field x number
---@field y number
---@field center_x number
---@field center_y number
---@field w number
---@field h number
---@field rotation number
---@field tile_fh boolean
---@field tile_fv boolean

---@class LevelTileset
---@field first_gid number
---@field end_gid number
---@field name string
---@field properties table

---@class LevelTilesets
---@field by_id LevelMapTile[]
---@field tilesets LevelTileset[]

---@class LevelMapTileData
---@field id number
---@field fv boolean
---@field fh boolean
---@field fd boolean

---@class Point
---@field x number
---@field y number

--vector3 is not vector3 here. I use it only to autocomplete worked. It will be tables with x,y,z
---@class LevelData
---@field size table {w,h}
---@field properties table
---@field ground table
---@field road table
---@field geometry table
---@field game_objects LevelMapObject[]
---@field visual_object LevelMapObject[]
---@field player LevelMapObject
---@field pathfinding table
