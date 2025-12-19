local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local BALANCE = require "game.balance"
local LUME = require "libs.lume"

local HASH_POSITION = hash("position")
local HASH_TEXCOORD0 = hash("texcoord0")
local HASH_AABB = hash("aabb")

local FACTORY_URL = msg.url("game_scene:/root#factory_tiled_layer")
local PARTS = {
    ROOT = hash("/root"),
    MESH_COMP = hash("mesh"),
}

local RESOURCE_IDX = 0


--   1 Quad == 2 triangles == 6 vertices
--   D-<----C
--   |    / |
--   | 2 /  |
--   |  / 1 |
--   | /    |
--   A-->---B
--A->B->C
--A->C->D
local TILE_POSITIONS_V = {
    vmath.vector3(0, 0, 0), vmath.vector3(1, 0, 0), vmath.vector3(1, 1, 0),
    vmath.vector3(0, 0, 0), vmath.vector3(1, 1, 0), vmath.vector3(0, 1, 0)
}

local TILE_UV_IDX = {
    1, 2, 3,
    1, 3, 4
}


local function tiled_create_default_native_buffer()
    return buffer.create(1, {
        { name = hash("position"),  type = buffer.VALUE_TYPE_FLOAT32, count = 3 },
        { name = hash("texcoord0"), type = buffer.VALUE_TYPE_FLOAT32, count = 2 },
    })
end

local function tiled_create_new_buffer()
    RESOURCE_IDX = RESOURCE_IDX + 1
    local name = "/runtime_buffer_tiled_" .. RESOURCE_IDX .. ".bufferc"
    local new_buffer = resource.create_buffer(name, { buffer = tiled_create_default_native_buffer() })

    ---@class TiledBufferResourceData
    local buffer_resource = {}
    buffer_resource.name = name
    buffer_resource.resource = new_buffer

    return buffer_resource
end


---@class DrawTileLayerSystem:EcsSystem
local System = CLASS.class("DrawTileLayerSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

local function create_layer(tiled_layers, atlas)
    local objects = collectionfactory.create(FACTORY_URL, nil, nil)
    local root = msg.url(assert(objects[PARTS.ROOT]))
    local mesh = LUME.url_component_from_url(root, PARTS.MESH_COMP)
    local resource = tiled_create_new_buffer()
    go.set(mesh, "vertices", resource.resource)
    go.set(mesh, 'texture0', atlas.texture)

    return {
        url = mesh,
        resource = resource.resource,
        tiled_layers = assert(tiled_layers),
        buffer = nil,
        buffer_size = -1,
        buffer_stream_position = {},
        buffer_stream_texcoord0 = {},
        atlas = atlas
    }
end

--https://discourse.mapeditor.org/t/tile-flipping-issue/5294/2
-- Function to swap UV
local function swap_uv(uv, v1, v2)
    uv[v1], uv[v2] = uv[v2], uv[v1]
end

local function flipUVHorizontal(uv)
    swap_uv(uv, 1, 2)
    swap_uv(uv, 3, 4)
end

local function flipUVVertical(uv)
    swap_uv(uv, 1, 4)
    swap_uv(uv, 2, 3)
end

local function flipUVAntiDiagonal(uv)
    swap_uv(uv, 3, 1)
end

local uv_idx = {}
function System:update_layer_mesh(layer, x1, y1, x2, y2)
    local BUFFER_DECLARATION = {
        { name = hash("position"),  type = buffer.VALUE_TYPE_FLOAT32, count = 3 },
        { name = hash("texcoord0"), type = buffer.VALUE_TYPE_FLOAT32, count = 2 }
    }

    assert(layer)
    local tile_size = BALANCE.config.tile_size

    local w = (x2 - x1) + 1
    local h = (y2 - y1) + 1
    assert(w > 0 and h > 0)

    local idx = 1
    local positions = layer.buffer_stream_position
    local texcoord0 = layer.buffer_stream_texcoord0

    for _, tiled_layer in ipairs(layer.tiled_layers) do
        for y = y1, y2 do
            for x = x1, x2 do
                local id = self.level:coords_to_id_unsafe(x, y) + 1 -- lua table start from 1 not 0
                local tile = tiled_layer.tiles[id]
                if tile then
                    local tile_data = tile and self.level:get_tile(tile.id)
                    local uv = assert(layer.atlas.data_by_id[tile_data.image], "no image:" .. tile_data.image).uvs
                    --set uv to vertices
                    uv_idx[1] = 1
                    uv_idx[2] = 4
                    uv_idx[3] = 3
                    uv_idx[4] = 2

                    if tile.fd then
                        flipUVAntiDiagonal(uv_idx)
                    end

                    if tile.fh then
                        flipUVHorizontal(uv_idx)
                    end

                    if tile.fv then
                        flipUVVertical(uv_idx)
                    end


                    -- 6 vertices per one quad
                    local index_p = (idx - 1) * 6 * 3
                    local index_texcoord = (idx - 1) * 6 * 2
                    for i = 1, 6 do
                        local v = TILE_POSITIONS_V[i]
                        positions[index_p + 1] = (x + v.x) * tile_size
                        positions[index_p + 2] = (y + v.y) * tile_size
                        positions[index_p + 3] = 0

                        index_p = index_p + 3

                        -- fill UV texture coorinates
                        local u = uv_idx[TILE_UV_IDX[i]] * 2 - 1
                        texcoord0[index_texcoord + 1] = uv[u]
                        texcoord0[index_texcoord + 2] = uv[u + 1]

                        index_texcoord = index_texcoord + 2
                    end
                    idx = idx + 1
                end
            end
        end
    end

    local buffer_size = (idx - 1) * 6
    local new_buffer = buffer_size ~= layer.buffer_size
    if new_buffer then
        layer.buffer = buffer.create(buffer_size, BUFFER_DECLARATION)
        layer.buffer_size = buffer_size
    end


    buffer_utils.fill_stream_floats(layer.buffer, HASH_POSITION, 3, positions)
    buffer_utils.fill_stream_floats(layer.buffer, HASH_TEXCOORD0, 2, texcoord0)

    buffer.set_metadata(layer.buffer, HASH_AABB, { x1 * tile_size, y1 * tile_size, 0, (x2 + 1) * tile_size, (y2 + 1) * tile_size, 0 },
        buffer.VALUE_TYPE_FLOAT32)

    resource.set_buffer(layer.resource, layer.buffer, {transfer_ownership = true})
end

function System:init_atlas()
    local atlas_path = hash("/assets/images/main.a.texturesetc")
    local atlas = resource.get_atlas(atlas_path)
    ---@diagnostic disable-next-line: param-type-mismatch
    local texture = hash(atlas.texture)

    local texture_info = resource.get_texture_info(texture)
    local w, h = texture_info.width, texture_info.height

    local data_by_id = {}

    for i = 1, #atlas.animations do
        local anim = atlas.animations[i]
        local geometry = atlas.geometries[anim.frame_start]
        local uvs = LUME.clone_shallow(geometry.uvs)

        --normalize uv
        for j = 0, 3 do
            uvs[j * 2 + 1] = uvs[j * 2 + 1] / w
            uvs[j * 2 + 2] = (h - uvs[j * 2 + 2]) / h
        end

        data_by_id[anim.id] = { id = anim.id, anim = anim, geometry = geometry, uvs = uvs }
    end

    return {
        texture = texture,
        w = w, h = h,
        data_by_id = data_by_id,
    }
end

function System:on_add_to_world()
    self.tile_size = BALANCE.config.tile_size
    self.tiles_borders = {
        x1 = 0, x2 = 0,
        y1 = 0, y2 = 0
    }
    self.level = self.world.game_world.level_creator.level

    self.atlas_tile = self:init_atlas()

    local layers = self.world.game_world.level_creator.layers

    local rows = 5
    local columns = 5

    local row_size = math.ceil(self.level.data.size.h / rows)
    local column_size = math.ceil(self.level.data.size.w / columns)
    local x, y = 0, 0
    local layers_list = { layers.ground, layers.road }
    local tile_idx = 1
    for _ = 1, rows do
        local y2 = math.min(y + row_size - 1, self.level.data.size.h - 1)
        x = 0
        for _ = 1, columns do
            local x2 = math.min(x + column_size - 1, self.level.data.size.w - 1)

            local layer = create_layer(layers_list, self.atlas_tile)
            self:update_layer_mesh(layer, x, y, x2, y2)
            --print(string.format("cell x(%d %d) y(%d %d)", x, x2, y, y2))
            x = x + column_size
            tile_idx = tile_idx + 1
        end
        y = y + row_size
    end
end

return System
