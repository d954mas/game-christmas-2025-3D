---@meta

---@class SmoothDumpNative
smooth_dump = smooth_dump or {}

---Smooth damp a vector towards a target, updating the current position and velocity in-place.
---@param current vector3 destination vector (modified)
---@param target vector3 desired target
---@param current_velocity vector3 velocity accumulator (modified)
---@param smooth_time number smoothing duration in seconds
---@param max_speed number maximum speed clamp
---@param max_distance number maximum allowed distance from the target
---@param dt number delta time step
function smooth_dump.smooth_dump_v3(current, target, current_velocity, smooth_time, max_speed, max_distance, dt) end
