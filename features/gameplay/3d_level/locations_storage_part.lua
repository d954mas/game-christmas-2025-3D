local CLASS = require "libs.class"
local ANALYTICS = require "features.sdk.analytics.analytics"
local LOCATIONS_DEF = require "features.gameplay.3d_level.location_def"


local StoragePart = require "features.core.storage.storage_part"

---@class LocationsPartOptions:StoragePart
local Storage = CLASS.class("LocationsPartOptions", StoragePart)

function Storage.new(storage) return CLASS.new_instance(Storage, storage) end

function Storage:initialize(storage)
    StoragePart.initialize(self, storage)
    self.locations = self.storage.data.locations
    if not self.locations then
        self.locations = {}
        self.storage.data.locations = self.locations
    end
end

function Storage:get_location(location_id)
    assert(LOCATIONS_DEF.BY_ID[location_id], "unknown location:" .. location_id)
    local location_data = self.locations[location_id]
    if not location_data then
        location_data = {
            objects = {},
            collected_objects = {},
            destroyed_objects = {},
            buildables = {},
            buildable_idx = 0,
        }
        self.locations[location_id] = location_data
    end
    return location_data
end

function Storage:find_object(data, object)
    for i = 1, #data.objects do
        if data.objects[i].id == object then
            return data.objects[i]
        end
    end
    error("no parent:", object.id)
end

function Storage:is_build(location_id, building_id)
    local data = self:get_location(location_id)
    if data.objects[building_id] then
        return true
    end
    return false
end

---@param location_id string
---@param object_id string
function Storage:build(location_id, object_id)
    local data = self:get_location(location_id)
    if data.objects[object_id] then return end

    data.objects[object_id] = {}--data for building
    ANALYTICS:building_build(location_id, object_id)
    self:save_and_changed()
end

function Storage:destroy_building(location_id, object_id)
    local data = self:get_location(location_id)
    if data.objects[object_id] then
        data.objects[object_id] = nil
        self:save_and_changed()
    end
end

function Storage:debug_reset_buildings(location_id)
    local data = self:get_location(location_id)
    data.objects = {}
    self:save_and_changed()
end

function Storage:is_collected(location_id, object_id)
    local data = self:get_location(location_id)
    return data.collected_objects[object_id]
end

function Storage:collect(location_id, object_id)
    local data = self:get_location(location_id)
    if not data.collected_objects[object_id] then
        data.collected_objects[object_id] = true
        self:save_and_changed()
    end
end

function Storage:is_destroyable_destroyed(location_id, object_id)
    local data = self:get_location(location_id)
    return data.destroyed_objects[object_id]
end

function Storage:destroy_destroyable(location_id, object_id)
    local data = self:get_location(location_id)
    if not data.destroyed_objects[object_id] then
        data.destroyed_objects[object_id] = true
        self:save_and_changed()
    end
end

function Storage:destroy_destroyable_respawn(location_id, object_id)
    local data = self:get_location(location_id)
    if data.destroyed_objects[object_id] then
        data.destroyed_objects[object_id] = false
        self:save_and_changed()
    end
end

return Storage
