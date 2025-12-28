local CONSTANTS = require "libs.constants"
local LUME = require "libs.lume"
local CLASS = require "libs.class"
local LOCATIONS = require "features.gameplay.3d_level.location_def"
local LOCATIONS_FEATURE = require "features.gameplay.3d_level.locations_feature"
local EVENTS = require "libs.events"

---@class LocationDataConfig
---@field objects LevelObjectData[]
---@field spawn_position vector3
---@field id string



local function v3_from_array(array) return vmath.vector3(array[1], array[2], array[3]) end

local function v4_from_array(array) return vmath.vector4(array[1], array[2], array[3], array[4]) end

local function quat_from_array(array) return vmath.quat(array[1], array[2], array[3], array[4]) end


---@class LocationData
local M = CLASS.class("LocationData")

function M.new(game) return CLASS.new_instance(M, game) end

---@param game GameWorld3D
function M:initialize(game)
    self.game = game
    ---@type LocationDataConfig
    self.data = nil
    self.location_changed = false
end


function M:load(id)
    self.def = assert(LOCATIONS.BY_ID[id], "no location:" .. id)
    if CONSTANTS.TARGET_IS_EDITOR and CONSTANTS.VERSION_IS_DEV and CONSTANTS.PLATFORM_IS_PC then
        local path = LUME.get_current_folder() .. self.def.path
        local file = assert(io.open(path, "r+"))
        local data = file:read("*a")
        file:close()
        ---@diagnostic disable-next-line: assign-type-mismatch
        self.data = json.decode(data)
    else
        self.data = load_from_resources.load_json(self.def.path)
    end

    self.data.spawn_position = v3_from_array(self.data.spawn_position)
    self.object_by_id = {}
    self.world_transforms = {}
    for _, object in ipairs(self.data.objects) do
        object.position = object.position and v3_from_array(object.position) or vmath.vector3()
        object.scale = object.scale and v3_from_array(object.scale) or vmath.vector3(1, 1, 1)
        object.rotation = object.rotation and quat_from_array(object.rotation) or vmath.quat_rotation_z(0)
        object.skin = "default"

        object.tint = object.tint and v4_from_array(object.tint) or vmath.vector4(1, 1, 1, 1)
        object.requirements = object.requirements or {}
        self.object_by_id[object.id] = object
    end
    self:trigger_location_changed()
  --  STORAGE.task:check_current_task(self)
end

function M:is_collected(id)
    return LOCATIONS_FEATURE.storage:is_collected(self.data.id, id)
end

function M:collect_object(id)
    if LOCATIONS_FEATURE.storage:is_collected(self.data.id, id) then return end
   assert(self.object_by_id[id], "no object:" .. id)
    EVENTS.LOCATION_COLLECTED:trigger(self.data.id, id)
    LOCATIONS_FEATURE.storage:collect(self.data.id, id)
end

function M:trigger_location_changed()
    self.location_changed = true
    self:recalculate_params()
end

function M:editor_add_object(object)
    print("add object:" .. object.id)
    assert(type(object) == "table")
    table.insert(self.data.objects, object)
    self.object_by_id[object.id] = object
    self:trigger_location_changed()
end

function M:editor_set_build(object_id, value)
    if value then
        self:build(object_id, true)
    else
        self:destroy_building(object_id)
    end
    self:trigger_location_changed()
end

function M:editor_remove_object(object)
    print("remove object:" .. object.id)
    assert(type(object) == "table")
    LUME.removei(self.data.objects, object)
    self.object_by_id[object.id] = object
    self:trigger_location_changed()
end

function M:is_build(id)
    local object = self.object_by_id[id]
    if not object then return true end
    if object.is_build_cache ~= nil then
        return object.is_build_cache
    end
    if object.parent and not self:is_build(object.parent) then
        object.is_build_cache = false
        return false
    end
   -- if object.location_percent and object.location_percent > self.location_progress_percent then
      --  object.is_build_cache = false
    --    return false
 --   end
    if object.is_ads then
        if not self.game:can_show_ads() then
            object.is_build_cache = false
            return false
        end
    end
    object.is_build_cache = true
    return true
end

function M:build(id, forced)
    assert(self.object_by_id[id], "no object:" .. id)
    if not forced then
        assert(not self:is_build(id))
        assert(self:object_have_all_requirments(id))
       -- assert(STORAGE.resources:can_spend(DEFS.RESOURCES.BY_ID.GOLD.id, object.cost))
       -- STORAGE.resources:spend(DEFS.RESOURCES.BY_ID.GOLD.id, object.cost)
       -- self.location_progress_value = self.location_progress_value + 1
      --  self.location_progress_percent = self.location_progress_value / self.location_progress_max
      --  ANALYTICS:location_build_value(self.data.id, self.location_progress_value)
       -- ANALYTICS:location_build_percent(self.data.id, self.location_progress_percent)
    end
    LOCATIONS_FEATURE.storage:build(self.data.id, id)
    self:recalculate_params()
    self.location_changed = true
end

function M:destroy_building(id)
    print("destroy_building object:" .. id)
    LOCATIONS_FEATURE.storage:destroy_building(self.data.id, id)
end

function M:object_have_all_requirments(id)
    local object = assert(self.object_by_id[id], "no object:" .. id)
    local parent = object.parent
    while parent do
        if not self:is_build(parent) then return false end
        parent = self.object_by_id[parent].parent
    end

 --   if object.location_percent > self.location_progress_percent then return false end

    for i = 1, 3 do
        local requirement = object.requirements[i]
        if requirement and not self:is_build(requirement) then return false end
    end
    return true
end

function M:recalculate_params()
    --reset is build cache
    for i = 1, #self.data.objects do
        local object = self.data.objects[i]
        object.is_build_cache = nil
    end
end


function M:find_by_id(id)
    return self.object_by_id[id]
end

function M:get_world_transform(id, forced)
    local transform
    if not forced then
        transform = self.world_transforms[id]
    end
    if not transform then
        local object = self.object_by_id[id]
        transform = vmath.matrix4()
        xmath.matrix_from_transforms(transform, object.position, object.scale, object.rotation)
        if object.parent then
            transform = self:get_world_transform(object.parent, forced) * transform
        end
        self.world_transforms[id] = transform
    end
    return transform
end

function M:transform_changed(id)
    self.world_transforms[id] = nil
    for _, object in ipairs(self.data.objects) do
        if object.parent == id then
            self:transform_changed(object.id)
        end
    end
end

return M
