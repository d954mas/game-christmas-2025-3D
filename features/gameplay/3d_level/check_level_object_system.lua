local CLASS = require "libs.class"
local ECS = require 'libs.ecs'
local LEVEL_OBJECTS_DEF = require "features.gameplay.3d_level.level_objects_def"


---@class CheckObjectsSystem:EcsSystem
local System = CLASS.class("CheckObjectsSystem", ECS.System)
System.filter = ECS.filter("object")

function System.new() return CLASS.new_instance(System) end

---@param e Entity
function System:check_object(e)
    local location_data = self.world.game_world.level_creator.location_data

    local def = LEVEL_OBJECTS_DEF.BY_ID[e.object_config.type]
    local is_build = location_data:is_build(e.object_config.id)
    if is_build and not e.object_entity and not def.no_object_entity then
        self.world:add_entity(self.world.game_world.ecs.entities:create_object_entity(e))
    end
    if not is_build and e.object_entity then
        self.world:remove_entity(e.object_entity)
    end
end

function System:update(_)
    local location_data = self.world.game_world.level_creator.location_data
    if not location_data.location_changed then return end

    local entities_list = self.entities_list
    for i = 1, #entities_list do
        self:check_object(entities_list[i])
    end

    location_data.location_changed = false
end

---@param e Entity
function System:on_remove(e)
    if e.object_entity then
        self.world:remove_entity(e.object_entity)
        e.object_entity = nil
    end
end

---@param e Entity
function System:on_add(e)
    self:check_object(e)
end

return System
