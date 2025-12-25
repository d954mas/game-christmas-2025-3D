---@meta

---@alias HBuffer userdata

---@class NativeIllumination
illumination = {}

--- Convert a floating point value to RGBA.
---@param value number
---@param min number
---@param max number
---@return number, number, number, number
function illumination.float_to_rgba(value, min, max) end

--- Fill a stream with uint8 data.
---@param index number
---@param buffer HBuffer
---@param stream_name string | hash
---@param components_size number
---@param data table<number>
function illumination.fill_stream_uint8(index, buffer, stream_name, components_size, data) end

--- Check if a box is visible within the frustum.
---@param matrix matrix4
---@param min_x number
---@param min_y number
---@param min_z number
---@param max_x number
---@param max_y number
---@param max_z number
---@return boolean
function illumination.frustum_is_box_visible(matrix, min_x, min_y, min_z, max_x, max_y, max_z) end

--- Initialize the lights manager.
--- @param numLights integer
--- @param xSlice integer
--- @param ySlice integer
--- @param zSlice integer
--- @param maxLightsPerCluster integer
function illumination.lights_init(numLights, xSlice, ySlice, zSlice, maxLightsPerCluster) end

--- Get the lights texture path.
---@return string
function illumination.lights_get_texture_path() end

--- Set the lights texture path.
---@param path string
function illumination.lights_set_texture_path(path) end

--- Set the lights frustum matrix.
---@param matrix matrix4
function illumination.lights_set_frustum(matrix) end

--- Set the lights view matrix.
---@param matrix matrix4
function illumination.lights_set_view(matrix) end

--- Set the camera field of view for the lights.
---@param fov number
function illumination.lights_set_camera_fov(fov) end

--- Set the camera far plane for the lights.
---@param far number
function illumination.lights_set_camera_far(far) end

--- Set the camera near plane for the lights.
---@param near number
function illumination.lights_set_camera_near(near) end

--- Set the camera aspect ratio for the lights.
---@param aspect number
function illumination.lights_set_camera_aspect(aspect) end

--- Get the texture size for the lights.
---@return number 
---@return number
function illumination.lights_get_texture_size() end

--- Get the maximum number of lights.
---@return number
function illumination.lights_get_max_lights() end

--- Get the maximum radius for the lights.
---@return number
function illumination.lights_get_max_radius() end

--- Get the borders along the X axis for the lights.
---@return number
function illumination.lights_get_borders_x() end

--- Get the borders along the Y axis for the lights.
---@return number
function illumination.lights_get_borders_y() end

--- Get the borders along the Z axis for the lights.
---@return number
function illumination.lights_get_borders_z() end

--- Get the X slice for the lights.
---@return number
function illumination.lights_get_x_slice() end

--- Get the Y slice for the lights.
---@return number
function illumination.lights_get_y_slice() end

--- Get the Z slice for the lights.
---@return number
function illumination.lights_get_z_slice() end

--- Get the number of lights per cluster.
---@return number
function illumination.lights_get_lights_per_cluster() end

--- Update the lights manager.
function illumination.lights_update() end

--- Create a light.
---@return Light
function illumination.light_create() end

--- Destroy a light.
---@param light_id number
function illumination.light_destroy(light_id) end

--- Get the total count of lights in the world.
---@return number
function illumination.lights_get_all_count() end

--- Get the number of visible lights in the world.
---@return number
function illumination.lights_get_visible_count() end

---@class Light
local Light = {}

--- Sets the position of the light.
---@param x number The X coordinate.
---@param y number The Y coordinate.
---@param z number The Z coordinate.
function Light:set_position(x, y, z) end

--- Gets the position of the light.
---@return number, number, number The X, Y, Z coordinates.
function Light:get_position() end

--- Sets the direction of the light.
---@param x number The X component of the direction vector.
---@param y number The Y component of the direction vector.
---@param z number The Z component of the direction vector.
function Light:set_direction(x, y, z) end

--- Gets the direction of the light.
---@return number, number, number The direction vector components.
function Light:get_direction() end

--- Sets the color and brightness of the light.
---@param r number The red component.
---@param g number The green component.
---@param b number The blue component.
---@param brightness number The brightness.
function Light:set_color(r, g, b, brightness) end

--- Gets the color and brightness of the light.
---@return number, number, number, number The color components and brightness.
function Light:get_color() end

--- Sets the brightness of the light.
---@param brightness number The brightness.
function Light:set_brightness(brightness) end

--- Gets the brightness of the light.
---@return number The brightness.
function Light:get_brightness() end

--- Sets the radius of the light.
---@param radius number The radius.
function Light:set_radius(radius) end

--- Gets the radius of the light.
---@return number The radius.
function Light:get_radius() end

--- Sets the smoothness of the light.
---@param smoothness number The smoothness.
function Light:set_smoothness(smoothness) end

--- Gets the smoothness of the light.
---@return number The smoothness.
function Light:get_smoothness() end

--- Sets the cutoff of the light.
---@param cutoff number The cutoff.
function Light:set_cutoff(cutoff) end

--- Gets the cutoff of the light.
---@return number The cutoff.
function Light:get_cutoff() end

--- Sets the specular intensity of the light.
---@param specular number The specular intensity.
function Light:set_specular(specular) end

--- Gets the specular intensity of the light.
---@return number The specular intensity.
function Light:get_specular() end

--- Sets whether the light is enabled.
---@param enabled boolean Whether the light is enabled.
function Light:set_enabled(enabled) end

--- Checks whether the light is enabled.
---@return boolean Whether the light is enabled.
function Light:is_enabled() end
