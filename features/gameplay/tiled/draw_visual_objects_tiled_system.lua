local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local LOG = require "libs.log"
local LUME = require "libs.lume"

local FACTORIES = {
    object_visual = msg.url("game_scene:/root#factory_tiled_visual_object"),
}

local PARTS = {
    ROOT = hash("/root"),
    SPRITE = hash("/sprite"),
    SPRITE_COMP = hash("sprite")
}

---@class DrawVisualObjectSystem:EcsSystem
local System = CLASS.class("DrawVisualObjectSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

System.filter = ECS.filter("visual_object")

---@param e Entity
function System:on_add(e)
    if (not e.visual_object_go) then
        local factory_id = e.level_map_object.properties.factory or "object_visual"
        local factory_url = FACTORIES[factory_id]
        if not factory_url then
            LOG.w("no factory:" .. e.level_map_object.properties.factory)
            factory_url = FACTORIES.object_visual
        end
        local collection = collectionfactory.create(factory_url, e.position, vmath.quat_rotation_z(math.rad(-e.level_map_object.rotation)), nil)
        ---@class VisualObjectGo
        local visual_object_go = {
            root = msg.url(assert(collection[PARTS.ROOT])),
            sprite = {
                root = msg.url(collection[PARTS.SPRITE]),
                sprite = nil,
            },
        }
        visual_object_go.sprite.sprite = LUME.url_component_from_url(visual_object_go.sprite.root, PARTS.SPRITE_COMP)
---@diagnostic disable-next-line: inject-field
        e.visual_object_go = visual_object_go
        if (e.level_map_object.tile_fv) then
            sprite.set_vflip(visual_object_go.sprite.sprite, true)
        end
        if (e.level_map_object.tile_fh) then
            sprite.set_hflip(visual_object_go.sprite.sprite, true)
        end


        if (factory_url == FACTORIES.object_visual) then
            sprite.play_flipbook(e.visual_object_go.sprite.sprite, e.tile_data.image_hash)
            --go.set_position(vmath.vector3(0, e.level_map_object.h / 2, 0.01), visual_object_go.sprite.root)
        end
    end
end

function System:on_remove(e)
    if e.visual_object_go then
        go.delete(e.visual_object_go.root, true)
        e.visual_object_go = nil
    end
end

return System
