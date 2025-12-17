---@meta

---@alias quat quaternion

---@class XMathSdk
xmath = {}

--* Arithmetic ----------------------------------------------------------------

---@overload fun(out:vector4, lhs:vector4, rhs:vector4)
---@param out vector3
---@param lhs vector3
---@param rhs vector3
function xmath.add(out, lhs, rhs) end

---@overload fun(out:vector4, lhs:vector4, rhs:vector4)
---@param out vector3
---@param lhs vector3
---@param rhs vector3
function xmath.sub(out, lhs, rhs) end

---@overload fun(out:vector4, lhs:vector4, rhs:vector4, scalar:number)
---@param out vector3
---@param lhs vector3
---@param scalar number
function xmath.mul(out, lhs, scalar) end

---@overload fun(out:vector4, lhs:vector4, rhs:number)
---@param out vector3
---@param lhs vector3
---@param rhs number
function xmath.div(out, lhs, rhs) end

--* Vector --------------------------------------------------------------------

---@param out vector3
---@param lhs vector3
---@param rhs vector3
function xmath.cross(out, lhs, rhs) end

---@overload fun(out:vector4, lhs:vector4, rhs:vector4)
---@param out vector3
---@param lhs vector3
---@param rhs vector3
function xmath.mul_per_elem(out, lhs, rhs) end

---@overload fun(out:vector4, input:vector4)
---@param out vector3
---@param input vector3
function xmath.normalize(out, input) end

---@param out vector3
---@param rotation quat
---@param input vector3
function xmath.rotate(out, rotation, input) end

---@overload fun(out:vector4, input:vector4|nil)
---@param out vector3
---@param input vector3|nil
function xmath.vector(out, input) end

---@param out vector3
---@param x number
---@param y number
---@param z number
function xmath.vector3_set_components(out, x, y, z) end

---@param out vector4
---@param x number
---@param y number
---@param z number
---@param w number
function xmath.vector4_set_components(out, x, y, z, w) end

--* Quaternion -----------------------------------------------------------------

---@param out quat
---@param input quat
function xmath.conj(out, input) end

---@param out quat
---@param axis vector3
---@param angle number
function xmath.quat_axis_angle(out, axis, angle) end

---@param out quat
---@param x vector3
---@param y vector3
---@param z vector3
function xmath.quat_basis(out, x, y, z) end

---@param out quat
---@param from vector3
---@param to vector3
function xmath.quat_from_to(out, from, to) end

---@param out quat
---@param angle number
function xmath.quat_rotation_x(out, angle) end

---@param out quat
---@param angle number
function xmath.quat_rotation_y(out, angle) end

---@param out quat
---@param angle number
function xmath.quat_rotation_z(out, angle) end

---@param out quat
---@param input quat|nil
function xmath.quat(out, input) end

---@param out quat
---@param input quat
function xmath.quat_reverse(out, input) end

---@param out quat
---@param lhs quat
---@param rhs quat
function xmath.quat_mul(out, lhs, rhs) end

---@param out vector3
---@param rotation quat
function xmath.quat_to_euler(out, rotation) end

---@param out quat
---@param euler vector3
function xmath.euler_to_quat(out, euler) end

--* Interpolation --------------------------------------------------------------

---@overload fun(out:vector3, t:number, from:vector3, to:vector3)
---@overload fun(out:vector4, t:number, from:vector4, to:vector4)
---@overload fun(out:quat, t:number, from:quat, to:quat)
---@param out number
---@param t number
---@param from number
---@param to number
function xmath.lerp(out, t, from, to) end

---@overload fun(out:vector4, t:number, from:vector4, to:vector4)
---@overload fun(out:quat, t:number, from:quat, to:quat)
---@param out vector3
---@param t number
---@param from vector3
---@param to vector3
function xmath.slerp(out, t, from, to) end

--* Matrix ---------------------------------------------------------------------

---@param out matrix4
---@param input matrix4|nil
function xmath.matrix(out, input) end

---@param out matrix4
---@param lhs matrix4
---@param rhs matrix4
function xmath.matrix_mul(out, lhs, rhs) end

---@param out vector4
---@param lhs matrix4
---@param rhs vector4
function xmath.matrix_mul_v4(out, lhs, rhs) end

---@param out matrix4
---@param input matrix4
function xmath.matrix_transpose(out, input) end

---@param out matrix4
---@param axis vector3
---@param angle number
function xmath.matrix_axis_angle(out, axis, angle) end

---@param out matrix4
---@param rotation quat
function xmath.matrix_from_quat(out, rotation) end

---@param out matrix4
---@param left number
---@param right number
---@param bottom number
---@param top number
---@param near_z number
---@param far_z number
function xmath.matrix_frustum(out, left, right, bottom, top, near_z, far_z) end

---@param out matrix4
---@param input matrix4
function xmath.matrix_inv(out, input) end

---@param out matrix4
---@param input matrix4
function xmath.matrix_from_matrix(out, input) end

---@param out matrix4
---@param eye vector3
---@param target vector3
---@param up vector3
function xmath.matrix_look_at(out, eye, target, up) end

---@param out matrix4
---@param left number
---@param right number
---@param bottom number
---@param top number
---@param near_z number
---@param far_z number
function xmath.matrix4_orthographic(out, left, right, bottom, top, near_z, far_z) end

---@param out matrix4
---@param input matrix4
function xmath.matrix_ortho_inv(out, input) end

---@param out matrix4
---@param fov number
---@param aspect number
---@param near_z number
---@param far_z number
function xmath.matrix4_perspective(out, fov, aspect, near_z, far_z) end

---@param out matrix4
---@param angle number
function xmath.matrix_rotation_x(out, angle) end

---@param out matrix4
---@param angle number
function xmath.matrix_rotation_y(out, angle) end

---@param out matrix4
---@param angle number
function xmath.matrix_rotation_z(out, angle) end

---@param out matrix4
---@param translation vector3|vector4
function xmath.matrix_translation(out, translation) end

---@param matrix matrix4
---@param translation vector3
---@param scale vector3
---@param rotation quat
function xmath.matrix_get_transforms(matrix, translation, scale, rotation) end

---@param matrix matrix4
---@param rotation quat
function xmath.matrix_get_transforms_quat(matrix, rotation) end

---@param matrix matrix4
---@param translation vector3
function xmath.matrix_get_transforms_translate(matrix, translation) end

---@param result matrix4
---@param translation vector3
---@param scale vector3
---@param rotation quat
function xmath.matrix_from_transforms(result, translation, scale, rotation) end

---@param result matrix4
---@param source matrix4
---@param scale vector3
function xmath.matrix_transform_set_scale(result, source, scale) end

--* Game Object helpers --------------------------------------------------------

---@param out matrix4
---@param instance hash|url
function xmath.go_get_world_matrix(out, instance) end

---@param out vector3
---@param instance hash|url
function xmath.go_get_world_position(out, instance) end

---@param out quat
---@param instance hash|url
function xmath.go_get_world_rotation(out, instance) end

---@param out_x vector3
---@param out_y vector3
---@param out_z vector3
---@param matrix matrix4
function xmath.calculate_direction_vectors(out_x, out_y, out_z, matrix) end

--* Type Queries ---------------------------------------------------------------

---@param value any
---@return boolean
function xmath.is_vector3(value) end

---@param value any
---@return boolean
function xmath.is_vector4(value) end

---@param value any
---@return boolean
function xmath.is_quat(value) end
