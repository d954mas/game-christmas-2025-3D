local CLASS = require "libs.class"
local MESH_TEXTURE = require "features.core.mesh_char.texture"

local MATH_MIN = math.min
local GO_SET = go.set
local TABLE_INSERT = table.insert

local HASH_VERTICES = hash("vertices")
local HASH_ANIMATION = hash("animation")
local HASH_TEXTURE3 = hash("texture3")

local TEMP_M = vmath.matrix4()
local TEMP_Q = vmath.quat()

local TEMP_V = vmath.vector4()

local TEMP_POS = vmath.vector3()
local TEMP_SCALE = vmath.vector3()

local BONES_WEIGHTS_TOTAL = {}
local BONES_WEIGHTS_CURRENT = {}


local function track_is_enabled(track)
	return track.enabled and track.weight > 0 and track.idx1
end

---@class BinMesh
local Mesh = CLASS.class("Mesh")

function Mesh.new(mesh_data) return CLASS.new_instance(Mesh, mesh_data) end

function Mesh:initialize(mesh_data)
	self.color = vmath.vector4(1.0, 1.0, 1.0, 1.0)
	self.mesh_data = assert(mesh_data)
	self.hash_texture_anim = HASH_TEXTURE3

	--weight  насколько сильно трек влияет на итоговый результат. Умножаем каждую кость на этот вес
	--bone_weights  насколько сильно кость влияет на итоговый результат
	--для трека 1 фактор всегда 1. Это начальное значение.
	self.tracks = {
		{ bones = mesh_char.new_bones_object_empty(self.mesh_data.bone_count), matrix_object = vmath.matrix4(), idx1 = nil, idx2 = nil, weight = 1.0, bone_weights = {}, enabled = true },
		{ bones = mesh_char.new_bones_object_empty(self.mesh_data.bone_count), matrix_object = vmath.matrix4(), idx1 = nil, idx2 = nil, weight = 1.0, bone_weights = {}, enabled = false }
	}

	for i = 1, #self.tracks do
		for j = -1, self.mesh_data.bone_count - 1 do
			self.tracks[i].bone_weights[j] = 1
		end
	end

	self.bones_native = mesh_char.new_bones_object_empty(self.mesh_data.bone_count)
	self.bones_tracks_result = mesh_char.new_bones_object_empty(self.mesh_data.bone_count)
	self.texture_active = nil
	self.frames_native_len = #self.mesh_data.frames_native

	self.matrix_frame = vmath.matrix4(self.mesh_data.local_.matrix)
end

function Mesh:set_use_texture(use_texture)
	if not self.texture and use_texture then
		self.texture = MESH_TEXTURE.create_bones_texture(self)
		self:on_texture_changed()
	elseif self.texture and not use_texture then
		MESH_TEXTURE.free_texture(self.texture)
		self.texture = nil
	end
end

function Mesh:add_animation(name, frames, frame_matrices)
	assert(name)
	assert(frames)
	local frames_len = #frames
	assert(frames_len > 0)
	assert(not self.mesh_data.animations[name], "animation:" .. name .. " already exist")
	self.mesh_data.animations[name] = { name = name, start = #self.mesh_data.frames_native + 1,
		finish = #self.mesh_data.frames_native + frames_len, length = frames_len }

	for i = 1, frames_len do
		TABLE_INSERT(self.mesh_data.frames_native, frames[i])
		TABLE_INSERT(self.mesh_data.frame_matrices, frame_matrices[i])
	end
end

function Mesh:calculate_bones()
	mesh_char.calculate_bones(self.bones_native, self.bones_tracks_result, self.mesh_data.inv_local_bones_native,
		self.mesh_data.local_.matrix, self.mesh_data.inv_local_matrix)
	mesh_char.mul_bones_by_matrix(self.bones_native, self.bones_native, self.matrix_frame)
end

function Mesh:calculate_track()
	local result = self.bones_tracks_result
	local first_track_idx = -1
	for i = 1, #self.tracks do
		if track_is_enabled(self.tracks[i]) then
			first_track_idx = i
			break
		end
	end
	if first_track_idx == -1 then
		mesh_char.bones_object_copy(result, self.mesh_data.frames_native[1])
		xmath.matrix_from_matrix(self.matrix_frame, self.mesh_data.world_.matrix)
		return
	end

	mesh_char.bones_object_copy(result, self.tracks[first_track_idx].bones)

	local total_weight = self.tracks[first_track_idx].weight
	local total_weight_object = self.tracks[first_track_idx].bone_weights[-1] * self.tracks[first_track_idx].weight

	xmath.matrix_from_matrix(self.matrix_frame, self.tracks[first_track_idx].matrix_object)

	for i = 0, self.mesh_data.bone_count - 1 do
		BONES_WEIGHTS_TOTAL[i] = self.tracks[first_track_idx].bone_weights[i] * self.tracks[first_track_idx].weight
	end

	for track_idx = first_track_idx + 1, #self.tracks do
		local track = self.tracks[track_idx]
		if track_is_enabled(track) then
			total_weight = total_weight + track.weight
			total_weight_object = total_weight_object + track.bone_weights[-1] * track.weight
			for i = 0, self.mesh_data.bone_count - 1 do
				local bone_weight = track.bone_weights[i] * track.weight
				BONES_WEIGHTS_TOTAL[i] = BONES_WEIGHTS_TOTAL[i] + bone_weight
				BONES_WEIGHTS_CURRENT[i] = bone_weight / BONES_WEIGHTS_TOTAL[i]
			end
			mesh_char.interpolate_matrix(self.matrix_frame, self.matrix_frame, track.matrix_object, track.bone_weights[-1] * track.weight / total_weight_object)
			mesh_char.interpolate(result, result, track.bones, BONES_WEIGHTS_CURRENT)
		end
	end
end

function Mesh:apply_armature()
	if self.mesh_data.texture_animations then
		if self.url then
			local active_tracks = 0
			local first_track
			for i = 1, #self.tracks do
				if track_is_enabled(self.tracks[i]) then
					active_tracks = active_tracks + 1
					if not first_track then first_track = self.tracks[i] end
				end
			end

			if active_tracks >= 2 or (first_track and first_track.idx2) then
				if not self.texture then
					self:set_use_texture(true)
				end
				if self.texture then
					self:set_texture_active(self.texture)
					MESH_TEXTURE.write_bones(self.texture_active, self.bones_native)
					resource.set_texture(self.texture_active.texture_id, self.texture_active.params, self.texture_active.buffer)
				end
			elseif first_track then
				self:set_texture_active(self.mesh_data.texture_animations)
				TEMP_V.x, TEMP_V.y = 1. / self.texture_active.width, (first_track.idx1 - 1) / self.texture_active.height
				TEMP_V.z, TEMP_V.w = 0, 0.
				GO_SET(self.url, HASH_ANIMATION, TEMP_V)
			else
				self:set_texture_active(self.mesh_data.texture_animations)
				TEMP_V.x, TEMP_V.y = 1. / self.texture_active.width, 0
				TEMP_V.z, TEMP_V.w = 0, 0.
				GO_SET(self.url, HASH_ANIMATION, TEMP_V)
			end
		end
	end
end

function Mesh:on_texture_changed()
	if self.url and self.texture then
		self:apply_armature()
	end
end

function Mesh:set_texture_active(texture)
	assert(texture)
	if self.texture_active ~= texture and self.url then
		self.texture_active = texture
		GO_SET(self.url, self.hash_texture_anim, self.texture_active.texture_id)
		--bones texture
		if self.texture_active == self.texture then
			TEMP_V.x = 1. / self.texture.width
			TEMP_V.y, TEMP_V.z, TEMP_V.w = 0, 0, 0
			GO_SET(self.url, HASH_ANIMATION, TEMP_V)
		end
	end
end

function Mesh:set_frame(track_idx, idx1, idx2, factor)
	track_idx = track_idx or 1
	--idx1 = math.floor(socket.gettime() * 2 % 100) + 1
	--idx1 = global_idx or 1
	--idx2 = nil
	local track = assert(self.tracks[track_idx])
	--	print("set frame:" .. idx1 .. " " .. tostring(idx2) .. " " .. tostring(factor))
	idx1 = MATH_MIN(idx1, self.frames_native_len)
	idx2 = idx2 and MATH_MIN(idx2, self.frames_native_len) or nil
	if track.idx1 ~= idx1 or track.idx2 ~= idx2 or track.factor ~= factor then
		--self.cache.bones = idx2 and self:interpolate(idx, idx2, factor) or self.mesh_data.frames[idx]

		if idx2 then
			mesh_char.interpolate(track.bones,
				assert(self.mesh_data.frames_native[idx1]), assert(self.mesh_data.frames_native[idx2]), assert(factor))
			xmath.matrix_from_matrix(track.matrix_object, assert(self.mesh_data.frame_matrices[idx1]))
			mesh_char.interpolate_matrix(track.matrix_object, track.matrix_object, assert(self.mesh_data.frame_matrices[idx2]), assert(factor))
		else
			mesh_char.bones_object_copy(track.bones, assert(self.mesh_data.frames_native[idx1]))
			xmath.matrix_from_matrix(track.matrix_object, assert(self.mesh_data.frame_matrices[idx1]))
		end

		track.idx1 = idx1
		track.idx2 = idx2
		track.factor = factor

		self:calculate_track()
		self:calculate_bones()
		self:apply_armature()
	end
end

function Mesh:find_animation_by_frame(frame)
	for k, v in pairs(self.mesh_data.animations) do
		if frame >= v.start and frame <= v.finish then
			return k
		end
	end
	return nil
end

function Mesh:clone()
	return Mesh.new(self.mesh_data)
end

function Mesh:set_mesh_component(url)
	assert(not self.url)
	self.url = assert(url)
	GO_SET(self.url, HASH_VERTICES, self.mesh_data.buffer_res)

	self:on_texture_changed()
	self:set_frame(1, 1)
end

function Mesh:dispose()
	if self.texture then
		MESH_TEXTURE.free_texture(self.texture)
		self.texture = nil
	end
end

function Mesh:get_bone_transform(idx)
	self.bones_tracks_result:get_bone_matrix(idx, TEMP_M)

	xmath.matrix_mul(TEMP_M, TEMP_M, self.mesh_data.inv_local_matrix)
	--xmath.matrix_mul(TEMP_M, TEMP_M, self.mesh_data.inv_world_matrix)
	xmath.matrix_mul(TEMP_M, TEMP_M, self.matrix_frame)
	xmath.matrix_transpose(TEMP_M, TEMP_M)
	xmath.matrix_get_transforms(TEMP_M, TEMP_POS, TEMP_SCALE, TEMP_Q)


	return TEMP_POS.x, TEMP_POS.y, TEMP_POS.z, TEMP_Q.x, TEMP_Q.y, TEMP_Q.z, TEMP_Q.w, TEMP_M
end

return Mesh
