---@meta

---@class imgui_gizmo
imgui_gizmo = {}

---Set ImGui context for ImGuizmo. Call once after imgui init.
function imgui_gizmo.set_context() end

---Set drawlist for ImGuizmo (default current window).
function imgui_gizmo.set_drawlist() end

---Set drawlist to ImGui foreground.
function imgui_gizmo.set_drawlist_foreground() end

---Set drawlist to ImGui background.
function imgui_gizmo.set_drawlist_background() end

---Set rect for gizmo drawing.
---@param x number
---@param y number
---@param width number
---@param height number
function imgui_gizmo.set_rect(x, y, width, height) end

---Use orthographic projection.
---@param value boolean
function imgui_gizmo.set_orthographic(value) end

---Enable or disable gizmo.
---@param value boolean
function imgui_gizmo.enable(value) end

---Return true if mouse is over gizmo.
---@return boolean
function imgui_gizmo.is_over() end

---Return true if mouse is over specific operation.
---@param operation number
---@return boolean
function imgui_gizmo.is_over_operation(operation) end

---Return true if mouse is over position within radius.
---@param position vector3
---@param radius number
---@return boolean
function imgui_gizmo.is_over_position(position, radius) end

---Return true if gizmo is used.
---@return boolean
function imgui_gizmo.is_using() end

---Return true if view gizmo is used.
---@return boolean
function imgui_gizmo.is_using_view_manipulate() end

---Return true if any gizmo is used.
---@return boolean
function imgui_gizmo.is_using_any() end

---Set gizmo size in clip space.
---@param value number
function imgui_gizmo.set_gizmo_size_clip_space(value) end

---Allow axis flip.
---@param value boolean
function imgui_gizmo.allow_axis_flip(value) end

---Set axis visibility limit.
---@param value number
function imgui_gizmo.set_axis_limit(value) end

---Hide axes by mask.
---@param x boolean
---@param y boolean
---@param z boolean
function imgui_gizmo.set_axis_mask(x, y, z) end

---Set plane visibility limit.
---@param value number
function imgui_gizmo.set_plane_limit(value) end

---Manipulate transform matrix.
---@param view matrix4
---@param projection matrix4
---@param operation number
---@param mode number
---@param matrix matrix4
---@param snap vector3|number|nil
---@param local_bounds table|nil
---@param bounds_snap vector3|number|nil
---@return boolean
---@return matrix4|nil
function imgui_gizmo.manipulate(view, projection, operation, mode, matrix, snap, local_bounds, bounds_snap) end

---Decompose matrix to translation, rotation (degrees), scale.
---@param matrix matrix4
---@return vector3
---@return vector3
---@return vector3
function imgui_gizmo.decompose_matrix(matrix) end

---Recompose matrix from translation, rotation (degrees), scale.
---@param translation vector3
---@param rotation vector3
---@param scale vector3
---@return matrix4
function imgui_gizmo.recompose_matrix(translation, rotation, scale) end

---Draw grid.
---@param view matrix4
---@param projection matrix4
---@param matrix matrix4
---@param grid_size number
function imgui_gizmo.draw_grid(view, projection, matrix, grid_size) end

---Set grid colors.
---@param minor vector4|table|number
---@param major vector4|table|number
---@param axis vector4|table|number
---If numbers are used, they must be RGBA in 0xRRGGBBAA format.
function imgui_gizmo.set_grid_colors(minor, major, axis) end

---Draw cubes from matrices array.
---@param view matrix4
---@param projection matrix4
---@param matrices table
function imgui_gizmo.draw_cubes(view, projection, matrices) end

---View manipulate (camera gizmo).
---@param view matrix4
---@param length number
---@param position vector3
---@param size vector3
---@param background_color number
function imgui_gizmo.view_manipulate(view, length, position, size, background_color) end

---View manipulate with projection and matrix.
---@param view matrix4
---@param projection matrix4
---@param operation number
---@param mode number
---@param matrix matrix4
---@param length number
---@param position vector3
---@param size vector3
---@param background_color number
function imgui_gizmo.view_manipulate(view, projection, operation, mode, matrix, length, position, size, background_color) end

---Get style table.
---@return table
function imgui_gizmo.get_style() end

---Set style from table.
---@param style table
function imgui_gizmo.set_style(style) end

---Get style color by index.
---@param index number
---@return vector4
function imgui_gizmo.get_style_color(index) end

---Set style color by index.
---@param index number
---@param color vector4|table
function imgui_gizmo.set_style_color(index, color) end

---Convert Euler degrees to quaternion.
---@param euler vector3
---@return quat
function imgui_gizmo.quat_from_euler(euler) end

---Convert basis vectors to quaternion.
---@param right vector3
---@param up vector3
---@param forward vector3
---@return quat
function imgui_gizmo.quat_from_basis(right, up, forward) end

---Look-at quaternion from position.
---@param position vector3
---@param target vector3
---@param up vector3
---@return quat
function imgui_gizmo.quat_look_at(position, target, up) end

imgui_gizmo.MODE_LOCAL = 0
imgui_gizmo.MODE_WORLD = 1

imgui_gizmo.OPERATION_TRANSLATE = 7
imgui_gizmo.OPERATION_ROTATE = 120
imgui_gizmo.OPERATION_SCALE = 896
imgui_gizmo.OPERATION_SCALEU = 14336
imgui_gizmo.OPERATION_UNIVERSAL = 15359
imgui_gizmo.OPERATION_TRANSLATE_X = 1
imgui_gizmo.OPERATION_TRANSLATE_Y = 2
imgui_gizmo.OPERATION_TRANSLATE_Z = 4
imgui_gizmo.OPERATION_ROTATE_X = 8
imgui_gizmo.OPERATION_ROTATE_Y = 16
imgui_gizmo.OPERATION_ROTATE_Z = 32
imgui_gizmo.OPERATION_ROTATE_SCREEN = 64
imgui_gizmo.OPERATION_SCALE_X = 128
imgui_gizmo.OPERATION_SCALE_Y = 256
imgui_gizmo.OPERATION_SCALE_Z = 512
imgui_gizmo.OPERATION_BOUNDS = 1024
imgui_gizmo.OPERATION_SCALE_XU = 2048
imgui_gizmo.OPERATION_SCALE_YU = 4096
imgui_gizmo.OPERATION_SCALE_ZU = 8192

imgui_gizmo.COLOR_DIRECTION_X = 0
imgui_gizmo.COLOR_DIRECTION_Y = 1
imgui_gizmo.COLOR_DIRECTION_Z = 2
imgui_gizmo.COLOR_PLANE_X = 3
imgui_gizmo.COLOR_PLANE_Y = 4
imgui_gizmo.COLOR_PLANE_Z = 5
imgui_gizmo.COLOR_SELECTION = 6
imgui_gizmo.COLOR_INACTIVE = 7
imgui_gizmo.COLOR_TRANSLATION_LINE = 8
imgui_gizmo.COLOR_SCALE_LINE = 9
imgui_gizmo.COLOR_ROTATION_USING_BORDER = 10
imgui_gizmo.COLOR_ROTATION_USING_FILL = 11
imgui_gizmo.COLOR_HATCHED_AXIS_LINES = 12
imgui_gizmo.COLOR_TEXT = 13
imgui_gizmo.COLOR_TEXT_SHADOW = 14
imgui_gizmo.COLOR_COUNT = 15
