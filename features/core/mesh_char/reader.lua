local RES_BUFFER_IDX = 0
local Mesh = require "features.core.mesh_char.mesh"

local STRING_BYTE = string.byte
local TABLE_INSERT = table.insert

local HASH_POSITION = hash("position")
local HASH_NORMAL = hash("normal")
local HASH_TEXCOORD0 = hash("texcoord0")
local HASH_WEIGHT = hash("weight")
local HASH_BONE = hash("bone")

local vec3 = vmath.vector3

local M = {}

function M.init_buffer(mesh)
	assert(not mesh.buffer)
	if #mesh.faces == 0 then return end
	local buf = buffer.create(#mesh.faces * 3, {
		{ name = HASH_POSITION, type = buffer.VALUE_TYPE_FLOAT32, count = 3 },
		{ name = HASH_NORMAL, type = buffer.VALUE_TYPE_FLOAT32, count = 3 },
		{ name = HASH_TEXCOORD0, type = buffer.VALUE_TYPE_FLOAT32, count = 2 },
		{ name = HASH_WEIGHT, type = buffer.VALUE_TYPE_FLOAT32, count = 4 },
		{ name = HASH_BONE, type = buffer.VALUE_TYPE_UINT8, count = 4 },
	})

	mesh.indices = {}

	local count = 1
	local bcount = 1

	local positions = {}
	local normals = {}
	local weights = {}
	local bones = {}

	for i = 1, #mesh.faces do
		local face = mesh.faces[i]
		for j = 1, #face.v do
			local idx = face.v[j]
			if not mesh.indices[idx] then
				mesh.indices[idx] = {}
			end
			TABLE_INSERT(mesh.indices[idx], count)

			local vertex = mesh.vertices[idx]
			local n = face.n or vertex.n

			positions[count] = vertex.p.x
			positions[count + 1] = vertex.p.y
			positions[count + 2] = vertex.p.z

			normals[count] = n.x
			normals[count + 1] = n.y
			normals[count + 2] = n.z
			--TOFIX: not correct for blendshaped face normals

			count = count + 3

			local skin = mesh.skin and mesh.skin[idx]
			local bone_count = skin and #skin or 0

			weights[bcount] = bone_count > 0 and skin[1].weight or 0
			weights[bcount + 1] = bone_count > 1 and skin[2].weight or 0
			weights[bcount + 2] = bone_count > 2 and skin[3].weight or 0
			weights[bcount + 3] = bone_count > 3 and skin[4].weight or 0

			bones[bcount] = bone_count > 0 and skin[1].idx or 0
			bones[bcount + 1] = bone_count > 1 and skin[2].idx or 0
			bones[bcount + 2] = bone_count > 2 and skin[3].idx or 0
			bones[bcount + 3] = bone_count > 3 and skin[4].idx or 0

			bcount = bcount + 4
		end
	end

	mesh_char.fill_stream_floats(buf, HASH_POSITION, 3, positions)
	mesh_char.fill_stream_floats(buf, HASH_NORMAL, 3, normals)
	mesh_char.fill_stream_floats(buf, HASH_TEXCOORD0, 2, mesh.texcoords)
	mesh_char.fill_stream_floats(buf, HASH_WEIGHT, 4, weights)
	mesh_char.fill_stream_uint8(buf, HASH_BONE, 4, bones)

	mesh.buffer = buf
	RES_BUFFER_IDX = RES_BUFFER_IDX + 1
	mesh.buffer_res = resource.create_buffer("/def-mesh/buffers/buffer" .. RES_BUFFER_IDX .. ".bufferc", { buffer = buf,
																										   transfer_ownership = true })
end

M.init_from_resource = function(path)
	M.content = sys.load_resource(path)
	M.index = 1
end

M.read_mesh = function()
	local mesh = {}
	local meshes = { mesh }

	local export_mesh = M.read_int() == 1
	--	print("EXPORT_MESH:" .. tostring(export_mesh))

	mesh.name = M.read_string()
	mesh.base = true --not a submesh

	mesh.local_ = M.read_transform()
	mesh.inv_local_matrix = vmath.inv(mesh.local_.matrix)
	mesh.world_ = M.read_transform()
	mesh.inv_world_matrix = vmath.inv(mesh.world_.matrix)

	local vertex_count = M.read_int()
	mesh.vertices = mesh_char.read_vertices(M.content, M.index, vertex_count)
	M.index = M.index + vertex_count * (2 * 3 * 2)
	--[[mesh.vertices = {}
	for i = 1, vertex_count do
		TABLE_INSERT(mesh.vertices,
				{
					p = M.read_vec3_half(),
					n = M.read_vec3_half()
				})
	end--]]

	local face_count = M.read_int()

	mesh.faces = mesh_char.read_faces(M.content, M.index, face_count)
	assert(#mesh.faces == face_count)
	M.index  = M.index +  face_count * 4 * 3

	--[[mesh.texcoords = {}
	local m = meshes[1]
	for i = 1, face_count * 6 do
		TABLE_INSERT(m.texcoords, M.read_half_float())
	end--]]
	mesh.texcoords =  mesh_char.read_texcoords(M.content,M.index, face_count)
	M.index = M.index + face_count*6*2

	local bone_count = M.read_int()

	mesh.bone_count = bone_count

	if export_mesh and bone_count == 0 then
		mesh.position = mesh.local_.position
		mesh.rotation = mesh.local_.rotation
		mesh.scale = mesh.local_.scale
		mesh.cache = {}
		return { Mesh.new(mesh) }
	end

	mesh.position = mesh.world_.position
	mesh.rotation = mesh.world_.rotation
	mesh.scale = mesh.world_.scale

	--reading armature
	--TODO: keep rigs separate from meshes for optimization

	mesh.skin = {}
	local max_weight_count = 0
	if export_mesh then
		for _ = 1, vertex_count do
			local data = {}
			local weight_count = M.read_int()
			max_weight_count = math.max(max_weight_count, weight_count)
			for _ = 1, weight_count do
				TABLE_INSERT(data,
						{
							idx = M.read_int(),
							weight = M.read_half_float()
						})
			end

			TABLE_INSERT(mesh.skin, data)
		end

		local precomputed = (M.read_int() == 1)
		assert(not precomputed)

		--		print("PRECOMPUTED:" .. tostring(precomputed))

		if not precomputed then
			mesh.inv_local_bones_native = mesh_char.read_bones_object(M.content, M.index, bone_count)
			M.index = M.index + bone_count * 3 * 4 * 2
		end
	end

	local frame_count = M.read_int()

	mesh.frames_native = {}
	mesh.frame_matrices = {}
	for _ = 1, frame_count do
		TABLE_INSERT(mesh.frame_matrices, M.read_transform().matrix)
		TABLE_INSERT(mesh.frames_native, mesh_char.read_bones_object(M.content, M.index, bone_count))
		M.index = M.index + bone_count * 3 * 4 * 2
	end

	mesh.animations = {
		---@class MeshAnimation
		default = { name = "default", start = 1, finish = #mesh.frames_native, length = #mesh.frames_native }
	}

	if export_mesh then
		M.init_buffer(mesh)
	end

	local result = {}
	for i = 1, #meshes do
		result[i] = Mesh.new(meshes[i])
	end
	return result
end

M.eof = function()
	return M.index > #M.content
end

M.read_string = function(size)
	local res = ""
	size = size or M.read_int()
	for _ = 1, size do
		local b = STRING_BYTE(M.content, M.index)
		res = res .. string.char(b)
		M.index = M.index + 1
	end
	return res
end

M.read_int = function()
	local n = mesh_char.read_int(M.content, M.index)

	M.index = M.index + 4
	return n
end

M.read_float = function()
	local result = mesh_char.read_float(M.content, M.index)
	M.index = M.index + 4
	return result
end

M.read_half_float = function()
	local result = mesh_char.read_half_float(M.content, M.index)
	M.index = M.index + 2
	return result
end


M.read_vec3_half = function()
	return vec3(M.read_half_float(), M.read_half_float(), M.read_half_float())
end



--read position, rotation and scale in Defold coordinates
M.read_transform = function()
	local res = {}
	local p = M.read_vec3_half()
	res.position = vec3(p.x, p.y, p.z)

	local euler = M.read_vec3_half()
	local qx = vmath.quat_rotation_x(euler.x)
	local qy = vmath.quat_rotation_y(euler.y)
	local qz = vmath.quat_rotation_z(euler.z)
	res.rotation = qy * qz * qx

	local s = M.read_vec3_half()
	res.scale = vec3(s.x, s.y, s.z)

	local mtx_rot = vmath.matrix4_rotation_x(euler.x) * vmath.matrix4_rotation_y(euler.y) * vmath.matrix4_rotation_z(euler.z)
	local mtx_tr = vmath.matrix4_translation(p)
	local mtx_scale = vmath.matrix4()
	mtx_scale.m00 = s.x
	mtx_scale.m11 = s.y
	mtx_scale.m22 = s.z

	res.matrix = vmath.matrix4()
	xmath.matrix_transpose(res.matrix,mtx_tr * mtx_rot * mtx_scale)

	return res
end

return M