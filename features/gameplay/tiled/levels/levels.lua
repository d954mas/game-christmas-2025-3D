local CONSTANTS = require "libs.constants"
local PARSER = require "features.tiled.levels.parser.parser"
local MAP_HELPER = require "features.tiled.levels.parser.map_helper"
local LOG = require "libs.log"
local Level = require "game.levels.level"

local TAG = "LEVELS"

local M = {}

M.LEVELS = {
	LEVEL_1 = "level_1",
}

---@type LevelTilesets
M.TILESET = nil

function M.load_tileset()
	local content = nil
	--load tileset from system
	if (CONSTANTS.PLATFORM_IS_PC and CONSTANTS.VERSION_IS_DEV) then
		local status, file = pcall(io.open, "./features/tiled/levels/result/tileset.json", "r")
		if (not status) then
			LOG.i("can't open file:" .. tostring(file), TAG)
		else
			if (file) then
				local result, read_err = file:read("*a")
				if (not result) then
					LOG.i("can't read file:\n" .. read_err, TAG)
				else
					content = result
				end
				file:close()
			end
		end
	else
		content = assert(sys.load_resource("/assets/custom/levels/tileset.json"), "no tileset")
	end
	M.TILESET = assert(json.decode(assert(content)), "can't parse tileset.json")

	for _, v in pairs(M.TILESET.tilesets) do
		v.properties = v.properties or {}
		local meta = { __index = v.properties }
		for i = v.first_gid, v.end_gid, 1 do
			local tile = M.TILESET.by_id[i]
			if (not tile or tile == json.null) then
				M.TILESET.by_id[i] = nil
			else
				if tile.image then tile.image_hash = hash(tile.image) end
				tile.properties = tile.properties or {}
				setmetatable(tile.properties, meta)
			--	print("TILE:" .. i .. tile.image)
			end
		end
	end
end

function M.update_tiled()
	if (CONSTANTS.PLATFORM_IS_WINDOWS) then
		os.execute("cd ./features/tiled/levels && resave_tiled_maps.sh")
	elseif (CONSTANTS.PLATFORM_IS_MACOS) then
		os.execute("cd ./features/tiled/levels && resave_tiled_maps_mac.sh")
	else
		os.execute("cd ./features/tiled/levels && resave_tiled_maps.sh")
	end
	PARSER.parse()
	M.load_tileset()

end

local function to_tiles_array(array, max_id)
	for i = 1, max_id do
		local str = tostring(i)
		if (array[str]) then
			array[i] = array[str]
			array[str] = nil
		end
		if (array[i]) then
			if(array[i] == 0)then
				array[i] = nil
			else
				array[i] = MAP_HELPER.tile_to_data(array[i])
			end
		end
	end
end

---@return Level
function M.load_level(name)
	local time = socket.gettime()
	LOG.i("load level:" .. name, TAG)
	assert(name, "no name")
	local content
	--restart to see correct result when add new tiles
	if (false and CONSTANTS.PLATFORM_IS_PC and CONSTANTS.VERSION_IS_DEV) then
		local file_path = "./assets/levels/levels/result/" .. name .. ".json"
		local status, file = pcall(io.open, file_path, "r")
		LOG.i("load local file:" .. file_path, TAG)
		if (not status) then
			LOG.i("can't open file:" .. file_path, TAG)
		else
			if (file) then
				local result, read_err = file:read("*a")
				if (not result) then
					LOG.i("can't read file:\n" .. read_err, TAG)
				else
					content = result
				end
				file:close()
			else
				error("no file:" .. file)
			end
		end
	else
		local path = "/assets/custom/levels/" .. name .. ".json"
		LOG.i("load resource:" .. path, TAG)
		content = assert(sys.load_resource(path), "no level:" .. name)
	end
	---@type LevelData
---@diagnostic disable-next-line: assign-type-mismatch
	local level_data = json.decode(content)
	local max_id = level_data.size.w * level_data.size.h
	to_tiles_array(level_data.ground, max_id)
	to_tiles_array(level_data.road, max_id)

	local level = Level.new(level_data, M.TILESET)
	level.name = name

	LOG.i("lvl:" .. name .. " loaded. Time:" .. (socket.gettime() - time), TAG)
	return level
end

return M
