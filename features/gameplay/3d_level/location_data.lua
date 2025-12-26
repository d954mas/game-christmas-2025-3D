local CONSTANTS = require "libs.constants"
local LUME = require "libs.lume"
local CLASS = require "libs.class"
local ANALYTICS = require "features.sdk.analytics.analytics_feature"
local LOCATIONS = require "features.gameplay.3d_level.location_def"

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

        object.tint = object.tint and v4_from_array(object.tint) or vmath.vector4(1, 1, 1, 1)
        object.requirements = object.requirements or {}
        self.object_by_id[object.id] = object
    end
    self:trigger_location_changed()
  --  STORAGE.task:check_current_task(self)
end

function M:is_collected(id)
    return STORAGE.locations:is_collected(self.data.id, id)
end

function M:collect_object(id)
    if STORAGE.locations:is_collected(self.data.id, id) then return end
    local object = assert(self.object_by_id[id], "no object:" .. id)
    if object.type == DEFS.OBJECTS.TYPES.OBJECT.OBJECTS.STAR.id then
        self.stars_collected = self.stars_collected + 1
    end
    if object.type == DEFS.OBJECTS.TYPES.OBJECT.OBJECTS.SKIN_PICKUP.id then
        STORAGE.skins:unlocked(object.skin)
    end
    STORAGE.locations:collect(self.data.id, id)
    STORAGE.task:check_current_task(self)
end

function M:trigger_location_changed()
    self.location_changed = true
    self:recalculate_params()
    self:refresh_location_progress()
    ----count again because objects with location percent >0 not count
    self:recalculate_params()
    self:refresh_location_progress()
    self:recalculate_params()
    self:refresh_location_progress()
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
        self:destroy(object_id)
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

--remove from storage objects that don't have need_button or cost == 0
function M:clear_location_storage()
    --local location_storage = assert(STORAGE.locations.locations[self.data.id], "no location:" .. self.data.id)

   -- for k, _ in pairs(location_storage.objects) do
       -- local object = self.object_by_id[k]
--if not object or not object.need_button or object.cost == 0 and not (object.requirements[1] or object.requirements[2] or object.requirements[3]) then
         --   location_storage.objects[k] = nil
        --    print("object removed:" .. k)
      --  end
   -- end
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
    if object.location_percent > self.location_progress_percent then
        object.is_build_cache = false
        return false
    end
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
    local object = assert(self.object_by_id[id], "no object:" .. id)
    if not forced then
        assert(not self:is_build(id))
        assert(self:object_have_all_requirments(id))
        assert(STORAGE.resources:can_spend(DEFS.RESOURCES.BY_ID.GOLD.id, object.cost))
        STORAGE.resources:spend(DEFS.RESOURCES.BY_ID.GOLD.id, object.cost)
        self.location_progress_value = self.location_progress_value + 1
        self.location_progress_percent = self.location_progress_value / self.location_progress_max
        ANALYTICS:location_build_value(self.data.id, self.location_progress_value)
        ANALYTICS:location_build_percent(self.data.id, self.location_progress_percent)
    end
    STORAGE.locations:build(self.data.id, id)
   -- STORAGE.task:build(id)
    STORAGE.task:check_current_task(self)
    self:recalculate_params()
    self.location_changed = true
    if object.is_island then
        self:refresh_terrain_status()
    end
end

function M:destroy(id)
    print("destroy object:" .. id)
    STORAGE.locations:destroy(self.data.id, id)
    self:refresh_location_progress()
    local object = self.object_by_id[id]
    if object and object.is_island then
        self:refresh_terrain_status()
    end
end

function M:refresh_location_progress()
    local max = 0
    local value = 0
    for i = 1, #self.data.objects do
        local object = self.data.objects[i]
        if object.need_button and object.cost > 0 then
            max = max + 1
            if self:is_build(object.id) then
                value = value + 1
            end
        end
    end
    self.location_progress_max = max
    self.location_progress_value = value
    self.location_progress_percent = self.location_progress_value / self.location_progress_max
end

function M:get_location_progress()
    return self.location_progress_value, self.location_progress_max
end

function M:is_location_builded()
    return self.location_progress_value >= self.location_progress_max
end

function M:object_have_all_requirments(id)
    local object = assert(self.object_by_id[id], "no object:" .. id)
    local parent = object.parent
    while parent do
        if not self:is_build(parent) then return false end
        parent = self.object_by_id[parent].parent
    end

    if object.location_percent > self.location_progress_percent then return false end

    for i = 1, 3 do
        local requirement = object.requirements[i]
        if requirement and not self:is_build(requirement) then return false end
    end
    return true
end

function M:button_can_build(id)
    local object = assert(self.object_by_id[id], "no object:" .. id)
    --  if self:is_build(id) then return false end
    --  if not self:object_have_all_requirments(id) then return false end
    if not STORAGE.resources:can_spend(DEFS.RESOURCES.BY_ID.GOLD.id, object.cost) then return false end
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
