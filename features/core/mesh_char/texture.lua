local HASH_RGBA = hash("rgba")
local LOG = require "libs.log"

local M = {}

local function next_pot(num)
	local result = 1
	while num > result do
		result = bit.lshift(result, 1)
	end
	return result
end
local TEXTURE_IDX = 0
function M.create_bones_texture(mesh)
	local width = next_pot(mesh.mesh_data.frames_native[1]:get_len() * 3 * 4)
	TEXTURE_IDX = TEXTURE_IDX + 1
	local path = "/__anim_bones_" .. mesh.mesh_data.name .. "_" .. TEXTURE_IDX .. ".texturec"

	print("creating animation texture for " .. path .. " width:" .. width .. "height:" .. 1)
	local tparams = {
		width = width,
		height = 1,
		type = graphics.TEXTURE_TYPE_2D,
		format = graphics.TEXTURE_FORMAT_RGBA,
	}
	local tbuffer = buffer.create(tparams.width * tparams.height, { { name = HASH_RGBA, type = buffer.VALUE_TYPE_UINT8, count = 4 } })

	local status, error = pcall(resource.create_texture, path, tparams, tbuffer)
	if status then
		return {
			params = tparams,
			texture_id = error,
			width = tparams.width,
			height = tparams.height,
			buffer = tbuffer
		}
	else
		LOG.e("can't create texture:" .. tostring(error))
	end
end

---@param mesh BinMesh
function M.bake_animation_texture(mesh)
	local width = next_pot(mesh.mesh_data.frames_native[1]:get_len() * 3 * 4)
	local height = next_pot(#mesh.mesh_data.frames_native)

	TEXTURE_IDX = TEXTURE_IDX + 1
	local path = "/__anim_" .. mesh.mesh_data.name .. "_" .. TEXTURE_IDX .. ".texturec"
	print("creating animation texture for " .. path .. " width:" .. width .. "height:" .. height)

	local tparams = {
		width = width,
		height = height,
		type = graphics.TEXTURE_TYPE_2D,
		format = graphics.TEXTURE_FORMAT_RGBA,
	}
	local tbuffer = buffer.create(tparams.width * tparams.height, { { name = HASH_RGBA, type = buffer.VALUE_TYPE_UINT8, count = 4 } })

	local status, error = pcall(resource.create_texture, path, tparams, tbuffer)
	if status then
		local texture = {
			params = tparams,
			texture_id = error,
			width = tparams.width,
			height = tparams.height,
			buffer = tbuffer
		}

		local index = 1
		local bones_result = mesh.bones_tracks_result
		for f = 1, #mesh.mesh_data.frames_native do
			--mesh.cache.bones = mesh.mesh_data.frames_native[f]
			mesh.bones_tracks_result = mesh.mesh_data.frames_native[f]
			mesh.matrix_frame = mesh.mesh_data.frame_matrices[f]
			mesh:calculate_bones()
			M.write_bones(texture, mesh.bones_native, index)
			index = index + tparams.width
		end
		mesh.bones_tracks_result = bones_result;

		resource.set_texture(texture.texture_id, texture.params, texture.buffer)
		return texture
	else
		LOG.e("can't create texture:" .. tostring(error))
	end
end

function M.write_bones(texture, bones_native, index)
	assert(texture.width >= bones_native:get_len() * 3 * 4)
	index = index or 1
	mesh_char.fill_texture_bones(texture.buffer, bones_native, index)
	--heavy for memory. A lot of gc calls to remove unused textures
	--resource.set_texture(texture.texture_id, texture.params, texture.buffer)
end

function M.free_texture(texture)
	print("free texture:" .. texture.texture_id)
	resource.release(texture.texture_id)
	texture.texture_id = nil
end

return M