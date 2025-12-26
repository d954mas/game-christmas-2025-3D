---@meta

---@class BonesClass
local BonesClass = {}

--- Get the length of the bones array
---@return number
function BonesClass:get_len() end

--- Count the bone transformations
---@param inv_local_bones BonesClass
---@param local_matrix matrix4
---@param inv_local_matrix matrix4
---@param out_bone_matrix matrix4
---@param bone_index number
---@return number
function BonesClass:count_bone(inv_local_bones, local_matrix, inv_local_matrix, out_bone_matrix, bone_index) end

--- Get the bone matrix
---@param bone_index number
---@param out_matrix matrix4
---@return number
function BonesClass:get_bone_matrix(bone_index, out_matrix) end

--- Get the bone transform
---@param bone_index number
---@param out_translation vector3
---@param out_scale vector3
---@param out_rotation quaternion
---@return number
function BonesClass:get_bone_transform(bone_index, out_translation, out_scale, out_rotation) end


---@class MeshChar
mesh_char= {}

--- Set bones for a GameObject.
---@param root_url string
---@param bones_table table
function mesh_char.go_set_bones(root_url, bones_table) end

--- Fill a stream with Vector4 data.
---@param buffer HBuffer
---@param stream_name string|hash
---@param data table
function mesh_char.fill_stream_v4(buffer, stream_name, data) end

--- Fill a stream with Vector3 data.
---@param buffer HBuffer
---@param stream_name string|hash
---@param data table
function mesh_char.fill_stream_v3(buffer, stream_name, data) end

--- Fill a stream with float data.
---@param buffer HBuffer
---@param stream_name string|hash
---@param components_size number
---@param data table
function mesh_char.fill_stream_floats(buffer, stream_name, components_size, data) end

--- Fill a stream with uint8 data.
---@param buffer HBuffer
---@param stream_name string|hash
---@param components_size number
---@param data table
function mesh_char.fill_stream_uint8(buffer, stream_name, components_size, data) end

--- Read a float value from a binary string.
---@param content string
---@param index number
---@return number
function mesh_char.read_float(content, index) end

--- Read a half-float value from a binary string.
---@param content string
---@param index number
---@return number
function mesh_char.read_half_float(content, index) end

--- Read vertices from a binary string.
---@param content string
---@param index number
---@param vertices number
---@return table
function mesh_char.read_vertices(content, index, vertices) end

--- Read texture coordinates from a binary string.
---@param content string
---@param index number
---@param faces number
---@return table
function mesh_char.read_texcoords(content, index, faces) end

--- Read faces from a binary string.
---@param content string
---@param index number
---@param faces number
---@return table
function mesh_char.read_faces(content, index, faces) end

--- Read an integer from a binary string.
---@param content string
---@param index number
---@return number
function mesh_char.read_int(content, index) end

--- Create a new bones object from a table.
---@param bones_table table
---@return BonesClass
function mesh_char.new_bones_object(bones_table) end

--- Read a bones object from a binary string.
---@param content string
---@param index number
---@param size number
---@return BonesClass
function mesh_char.read_bones_object(content, index, size) end

--- Create a new empty bones object.
---@param size number
---@return BonesClass
function mesh_char.new_bones_object_empty(size) end

--- Copy a bones object.
---@param out_bones BonesClass
---@param in_bones BonesClass
function mesh_char.bones_object_copy(out_bones, in_bones) end

--- Calculate bones transformations.
---@param out_bones BonesClass
---@param in_bones BonesClass
---@param inv_local_bones BonesClass
---@param local_matrix matrix4
---@param inv_local_matrix matrix4
function mesh_char.calculate_bones(out_bones, in_bones, inv_local_bones, local_matrix, inv_local_matrix) end

--- Multiply bones by a matrix.
---@param out_bones BonesClass
---@param in_bones BonesClass
---@param matrix matrix4
function mesh_char.mul_bones_by_matrix(out_bones, in_bones, matrix) end

--- Fill texture bones.
---@param buffer HBuffer
---@param bones BonesClass
---@param index number
function mesh_char.fill_texture_bones(buffer, bones, index) end

--- Interpolate between two bones.
---@param out_bones BonesClass
---@param bones1 BonesClass
---@param bones2 BonesClass
---@param factor number|table
function mesh_char.interpolate(out_bones, bones1, bones2, factor) end

--- Interpolate between two matrices.
---@param out_matrix matrix4
---@param matrix1 matrix4
---@param matrix2 matrix4
---@param factor number
function mesh_char.interpolate_matrix(out_matrix, matrix1, matrix2, factor) end

--- Get the rotation quaternion from a matrix.
---@param matrix matrix4
---@param out_quat quaternion
function mesh_char.matrix_get_rotation(matrix, out_quat) end
