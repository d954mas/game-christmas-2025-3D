local READER = require "features.core.mesh_char.reader"
local MESH_TEXTURE = require "features.core.mesh_char.texture"
local ANIMATIONS = require "features.core.mesh_char.mesh_char_animations_def"

local HASH_AABB = hash("AABB")

local M = {
	animations = {},
	meshes = {}
}
--The mesh component looks for a AABB meta data with 6 floats: (minx, miny, minz), (maxx, maxy, maxz)
local BASE_AABB = { -2, -2, -2, 2, 2, 2 }
local MESHES_LIST = {
	{ name = "char_base",    file = "char_base.bin",    aabb = BASE_AABB },
}

local function load_meshes()
	for _, mesh_data in ipairs(MESHES_LIST) do
		print("load mesh:" .. mesh_data.file)
		READER.init_from_resource("/assets/custom/mesh/" .. mesh_data.file)
		local mesh = READER.read_mesh()[1]
		print(mesh.mesh_data.name .. " " .. #mesh.mesh_data.faces .. " triangles")
		assert(READER.eof(),
			"file have more than one mesh. Index:" .. READER.index .. " Content:" .. #READER.content .. " diff:" .. #READER.content - READER.index)
		M.meshes[mesh_data.name] = mesh
		if mesh_data.aabb then
			buffer.set_metadata(mesh.mesh_data.buffer, HASH_AABB, mesh_data.aabb, buffer.VALUE_TYPE_FLOAT32)
		end
	end
end

local function load_animations()
	for _, animation in ipairs(ANIMATIONS.LOAD_LIST) do
		print("load animation:" .. animation.file)
		READER.init_from_resource("/assets/custom/mesh/animations/" .. animation.file)
		local mesh = READER.read_mesh()[1]
		assert(READER.eof(), "file have more than one mesh")
		local frames = #mesh.mesh_data.frames_native
		assert(frames > 0)
		animation.frames = frames
		animation.frames_native = mesh.mesh_data.frames_native
		animation.frame_matrices = mesh.mesh_data.frame_matrices
	end
end

function M.load()
	local time_start = chronos.nanotime()
	load_meshes()
	print("mesh load:" .. (chronos.nanotime() - time_start))
	local time = chronos.nanotime()
	load_animations()
	print("animation load:" .. (chronos.nanotime() - time))

	time = chronos.nanotime()
	local mesh_base = assert(M.meshes["char_base"])
	for _, animation in ipairs(ANIMATIONS.LOAD_LIST) do
		mesh_base:add_animation(animation.id, animation.frames_native, animation.frame_matrices)
	end
	mesh_base.mesh_data.texture_animations = MESH_TEXTURE.bake_animation_texture(mesh_base)
	for _, v in pairs(M.meshes) do
		if v ~= mesh_base then
			v.mesh_data.animations = mesh_base.mesh_data.animations
			v.mesh_data.frames_native = mesh_base.mesh_data.frames_native
			v.mesh_data.frame_matrices = mesh_base.mesh_data.frame_matrices
			v.mesh_data.texture_animations = mesh_base.mesh_data.texture_animations
		end
	end
	print("add animations:" .. (chronos.nanotime() - time))
	print("mesh total loading", (chronos.nanotime() - time_start))
end

---@return BinMesh
function M.get_mesh(name)
	local mesh = assert(M.meshes[name], "no mesh with name:" .. name)
	return mesh:clone()
end

return M
