local CLASS = require "libs.class"
local ECS = require 'libs.ecs'
local LEVEL_OBJECTS_DEF = require "features.gameplay.3d_level.level_objects_def"
local LUME = require "libs.lume"
local HASHES = require "libs.hashes"

local PARTS = {
    ROOT = hash("/root"),
}

local HASH_PHONG = hash("phong")
local HASH_SCALE = hash("scale")

local SCALE_INIT = vmath.vector3(0.01)



---@class CreateLevelObjectEntityDefaultSystem:EcsSystem
local System = CLASS.class("CreateLevelObjectEntityDefaultSystem", ECS.System)
System.filter = ECS.filter("object_entity_default")

function System.new() return CLASS.new_instance(System) end

---@param e Entity
function System:on_add(e)
    ---@class Entity
    e = e
    local def = LEVEL_OBJECTS_DEF.BY_ID[e.object_config_entity.object_config.type]
    local skin = assert(def.skins_by_id[e.object_config_entity.object_config.skin], "no skin:" .. e.object_config_entity.object_config.skin)

    ---@diagnostic disable-next-line: param-type-mismatch
    local urls = collectionfactory.create(assert(skin.factory), e.position, e.rotation, nil, e.scale)
    e.object_entity_default_urls = urls
    assert(not e.object_entity_default_go)
    ---@class ObjectEntityDefaultGo
    local object_go = {
        root = msg.url(assert(urls[PARTS.ROOT])),
        models = {},
        collisions = {},
        config = {
        }
    }
    e.object_entity_default_go = object_go


    for i = 1, #skin.models do
        local model = skin.models[i]
        local root_url = msg.url(assert(urls[model.root]))
        local model_go = {
            root = root_url,
            model = LUME.url_component_from_url(root_url, assert(model.model)),
            tint = vmath.vector4(e.tint),
        }
        xmath.mul_per_elem(model_go.tint, e.tint, model.tint)
        e.object_entity_default_go.models[i] = model_go
        go.set(model_go.model, HASHES.TINT, model_go.tint)


        local need_animate = self.world.game_world.state.time > 0.2
        if need_animate then
            local scale = go.get_scale(model_go.root)
            go.set_scale(SCALE_INIT, model_go.root)
            go.animate(model_go.root, HASH_SCALE, go.PLAYBACK_ONCE_FORWARD, scale, go.EASING_OUTQUAD, 0.33)
        end
        local phong = skin.phong or model.phong
        if phong then
            go.set(model_go.model, HASH_PHONG, phong)
        end
    end



    local scale = math.min(e.scale.x, e.scale.y, e.scale.z)

    local scale_x = e.scale.x / scale
    local scale_y = e.scale.y / scale
    local scale_z = e.scale.z / scale

    local uniform_scale = scale_x == scale_y and scale_x == scale_z


    for i = 1, #skin.collisions do
        local collision = skin.collisions[i]
        local root_url = msg.url(assert(urls[collision.root]))
        local collision_obj = {
            root = root_url,
            collision = LUME.url_component_from_url(root_url, assert(collision.collision))
        }
        e.object_entity_default_go.collisions[i] = collision_obj
        if def.scale_set_shape_size and not uniform_scale and collision.shapes then
            for j = 1, #collision.shapes do
                local shape_name = collision.shapes[j]
                local shape = physics.get_shape(collision_obj.collision, shape_name)
                if shape.type == physics.SHAPE_TYPE_BOX then
                    local x, y, z = shape.dimensions.x * scale_x, shape.dimensions.y * scale_y, shape.dimensions.z * scale_z
                    xmath.vector3_set_components(shape.dimensions, x, y, z)
                    ---@diagnostic disable-next-line: param-type-mismatch
                    physics.set_shape(collision_obj.collision, shape_name, shape)
                elseif shape.type == physics.SHAPE_TYPE_SPHERE then
                    --can't scale sphere
                elseif shape.type == physics.SHAPE_TYPE_CAPSULE then
                    local new_height = (shape.diameter + shape.height) * scale_y

                    local scale_capsule = math.max(scale_x, scale_z) -- Uniform scaling for poles using the larger of x or z
                    shape.diameter = math.max(shape.diameter * scale_capsule, 0.01)

                    shape.height = math.max(new_height - shape.diameter, 0.01)
                    ---@diagnostic disable-next-line: param-type-mismatch
                    physics.set_shape(collision_obj.collision, shape_name, shape)
                elseif shape.type == physics.SHAPE_TYPE_HULL then
                    --can't scale hull
                end
            end
        end
    end


    self.world.game_world.ecs.entities:object_add_collision(e, e.object_entity_default_go)

    self.world:add_entity(e)

    return e
end

---@param e Entity
function System:on_remove(e)
    if e.object_entity_default_go then
        go.delete(e.object_entity_default_go.root, true)
        self.world.game_world.ecs.entities:object_remove_collision(e.object_entity_default_go)
        e.object_entity_default_go = nil
    end
end

return System
