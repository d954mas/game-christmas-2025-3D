---@meta

---@class physics_utils
physics_utils = {}

---@class PhysicsObject
local PhysicsObject = {}

function PhysicsObject:destroy() end

function PhysicsObject:set_update_position(update) end

---Create a physics object userdata used by native helpers.
---@param root_url url|hash|userdata
---@param collision_url url|hash|userdata
---@param position vector3
---@param velocity vector3
---@return PhysicsObject
function physics_utils.new_physics_object(root_url, collision_url, position, velocity) end


function physics_utils.physics_objects_update_variables() end

function physics_utils.physics_objects_update_linear_velocity() end

---Check if a physics raycast hits anything.
---@param from vector3
---@param to vector3
---@param groups number
---@return boolean
function physics_utils.physics_raycast_single_exist(from, to, groups) end

---Perform a physics raycast and return the hit.
---@param from vector3
---@param to vector3
---@param groups number
---@return table|nil
function physics_utils.physics_raycast_single(from, to, groups) end

---Count bits in a collision mask.
---@param mask hash[]
---@return number
function physics_utils.physics_count_mask(mask) end
