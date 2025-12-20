local IS_DEFOLD = msg --is run in defold bundle or from sh
local reqf = require  --fixed defold build error


local lfs
local cjson
local bit
local path_symbol = "\\"
--Sh
--need lfs, cjson and bit from luarocks
if (not IS_DEFOLD) then
	--   package.path = package.path .. ';..\\..\\..\\..\\?.lua'
	lfs = reqf "lfs"
	cjson = reqf "cjson"
	json = {
		encode = cjson.encode,
		decode = cjson.decode
	}
	bit = reqf "bit"
else
	lfs = _G.lfs
	bit = _G.bit
end

local M = {}

local MAP_HELPER = require "features.gameplay.tiled.levels.parser.map_helper"

local TAG = "LEVEL_PARSER"

local LOG
if IS_DEFOLD then
	LOG = require "libs.log"
else
	local ok, module = pcall(require, "libs.log")
	if ok then LOG = module end
end

local function log(message)
	message = tostring(message)
	if LOG and LOG.i then
		LOG.i(message, TAG)
	else
		print(message)
	end
end

local LEVELS_PATH = "features/gameplay/tiled/levels/levels/lua"
local TILESETS_PATH = "features/gameplay/tiled/levels/tilesets"
local RESULT_PATH = "features/gameplay/tiled/levels/levels/result"
local RES_PATH = "assets/custom/levels"
local NEED_PRETTY = false

--region pretty json
local cat = table.concat
local sub = string.sub
local rep = string.rep
local function pretty(s, lf, id, ac)
	lf, id, ac = lf or "\n", id or "     ", ac or " "
	local i, j, k, n, r, p, q = 1, 0, 0, #s, {}, nil, nil
	local al = sub(ac, -1) == "\n"
	for x = 1, n do
		local c = sub(s, x, x)
		if not q and (c == "{" or c == "[") then
			r[i] = p == ":" and cat { c, lf } or cat { rep(id, j), c, lf }
			j = j + 1
		elseif not q and (c == "}" or c == "]") then
			j = j - 1
			if p == "{" or p == "[" then
				i = i - 1
				r[i] = cat { rep(id, j), p, c }
			else
				r[i] = cat { lf, rep(id, j), c }
			end
		elseif not q and c == "," then
			r[i] = cat { c, lf }
			k = -1
		elseif not q and c == ":" then
			r[i] = cat { c, ac }
			if al then
				i = i + 1
				r[i] = rep(id, j)
			end
		else
			if c == '"' and p ~= "\\" then
				q = not q and true or nil
			end
			if j ~= k then
				r[i] = rep(id, j)
				i, k = i + 1, j
			end
			r[i] = c
		end
		p, i = c, i + 1
	end
	return cat(r)
end
--endregion

if (cjson) then
	-- cjson.encode_sparse_array(false)
	--cjson.decode_invalid_numbers(false)
end


---@type LevelTilesets
local TILESETS


--parse tilesets from tilesets.json
local function parse_tilesets(path)
	assert(path)
	log("parse tilesets")
	---@diagnostic disable-next-line: cast-local-type
	TILESETS = nil
	assert(not TILESETS, "tileset already loaded")

	local tiled = dofile(path)
	local id_to_tile = {}
	local tilesets = {}
	for _, tileset in ipairs(tiled.tilesets) do
		log("parse tileset:" .. tileset.name)
		assert(not tilesets[tileset.name], "tileset with name:" .. tileset.name .. " already created")
		tilesets[tileset.name] = { first_gid = tileset.firstgid, end_gid = tileset.firstgid + tileset.tiles[#tileset.tiles].id, name = tileset.name,
			properties = tileset.properties or {} }
		for _, tile in ipairs(tileset.tiles) do
			---@type TileProperties
			tile.properties = tile.properties or {}
			id_to_tile[tile.id + tileset.firstgid] = tile
			tile.id = tile.id + tileset.firstgid
			tile.width = nil
			tile.height = nil
			--  tile.width = tile.width or tile.size or tileset.tilewidth
			--   tile.height = tile.height or tile.size or tileset.tileheight
			--use metatable to copy tileset properties to tile properties
			--when load in game, need setmetatable again
			setmetatable(tile.properties, { __index = tileset.properties })
			if tile.image then
				local image_path = tile.image
				local pathes = {}
				for word in string.gmatch(image_path, "([^/]+)") do
					table.insert(pathes, word)
				end
				--split path
				--use only image name
				-- tile.atlas = pathes[#pathes - 1]
				tile.image = string.sub(pathes[#pathes], 1, string.find(pathes[#pathes], "%.") - 1)
			end --]]
		end
	end
	TILESETS = { by_id = id_to_tile, tilesets = tilesets }
	log("parse tilesets done")
end


--create base level data
---@return LevelData
local function create_map_data(tiled)
	local data = {}
	data.size = { w = tiled.width, h = tiled.height }
	data.properties = tiled.properties
	return data
end



--Check that id same for cells
--Use same id for cell in all maps.
--Change tileset order for level file when need
local function check_tilesets(tiled)
	local layers_new_data = {}
	for _, tileset in ipairs(tiled.tilesets) do
		if tileset.firstgid ~= TILESETS.tilesets[tileset.name].first_gid then
			log("update tileset:" .. tileset.name)
			local end_gid = tileset.firstgid + TILESETS.tilesets[tileset.name].end_gid - TILESETS.tilesets[tileset.name].first_gid
			for _, layer in ipairs(tiled.layers) do
				local new_data = layers_new_data[layer] or {}
				layers_new_data[layer] = new_data
				local firstgid_delta = TILESETS.tilesets[tileset.name].first_gid - tileset.firstgid
				if layer.data then
					for i, v in ipairs(layer.data) do
						local tile = MAP_HELPER.tile_to_data(v)
						if tile.id >= tileset.firstgid and tile.id <= end_gid then
							assert(not new_data[i], "cell already processed")
							new_data[i] = tile.id + firstgid_delta
							if (tile.fd) then new_data[i] = bit.bor(new_data[i], MAP_HELPER.FLIPPED_DIAGONALLY_FLAG) end
							if (tile.fh) then new_data[i] = bit.bor(new_data[i], MAP_HELPER.FLIPPED_HORIZONTALLY_FLAG) end
							if (tile.fv) then new_data[i] = bit.bor(new_data[i], MAP_HELPER.FLIPPED_VERTICALLY_FLAG) end
							layer.data[i] = -1 --processed cell
						end
					end
				end
				if layer.objects then
					for _, obj in ipairs(layer.objects) do
						if obj.gid and not obj._tileset_processed then
							local tile = MAP_HELPER.tile_to_data(obj.gid)
							if tile.id >= tileset.firstgid and tile.id <= end_gid then
								tile.id = tile.id + firstgid_delta
								if (tile.fd) then tile.id = bit.bor(tile.id, MAP_HELPER.FLIPPED_DIAGONALLY_FLAG) end
								if (tile.fh) then tile.id = bit.bor(tile.id, MAP_HELPER.FLIPPED_HORIZONTALLY_FLAG) end
								if (tile.fv) then tile.id = bit.bor(tile.id, MAP_HELPER.FLIPPED_VERTICALLY_FLAG) end
								obj.gid = tile.id
								obj._tileset_processed = true
							end
						end
					end
				end
			end
		end
	end
	for _, layer in ipairs(tiled.layers) do
		local new_data = layers_new_data[layer]
		if new_data then
			for idx, v in pairs(new_data) do
				assert(layer.data[idx] == -1, "can't set for unprocessed cell")
				layer.data[idx] = v
			end
		end
		if layer.objects then
			for _, obj in ipairs(layer.objects) do
				obj._tileset_processed = nil
			end
		end
	end
end

--region repack
--change Y-down to Y-top
local function repack_layer(array, tiled, _)
	assert(array)
	assert(tiled)
	local width = tiled.width
	local height = #array / width
	local cells = {}
	for y = 1, height do
		for x = 1, width do
			local tiled_cell = assert(array[(y - 1) * width + x])
			local new_coords = (height - y) * width + x
			cells[new_coords] = tiled_cell
		end
	end
	assert(#cells == #array)
	for i = 1, #cells do
		array[i] = cells[i]
	end
end

--change Y-down to Y-top
--make some precalculation
local function repack_objects(array, tiled, _)
	assert(array)
	assert(tiled)
	local total_height = tiled.height * tiled.tileheight
	for _, object in ipairs(array) do
		local x, y = object.x, object.y
		y = total_height - y
		object.x, object.y = x, y

		if (object.polygon) then
			for _, v in ipairs(object.polygon) do
				v.y = -v.y
			end
		end

		if (object.polyline) then
			for _, v in ipairs(object.polyline) do
				v.y = -v.y
			end
		end
	end
end


--parse objects. Save only needed data
--calculate center positions
local function prepare_objects(array, tiled, _)
	assert(array)
	assert(tiled)
	for i, object in ipairs(array) do
		--assert(object.gid or object.rotation == 0, "object rotation should be 0.Use flip when need.")
		local object_data = {
			tile_id = object.gid, properties = object.properties or {}, x = object.x, y = object.y,
			w = object.width, h = object.height, name = object.name, shape = object.shape,
			polygon = object.polygon, polyline = object.polyline, rotation = object.rotation,
			text = object.text, pixelsize = object.pixelsize
		}
		if object.gid then
			local tile_data = MAP_HELPER.tile_to_data(object.gid)
			print("parse object:" .. object.name .. " gid:" .. object.gid .. " tile_data:" .. tostring(tile_data))
			object_data.tile_id = tile_data.id --i have no idea but objects here is 1 less then needed. WTF
			object_data.tile_fv = tile_data.fv
			object_data.tile_fh = tile_data.fh
			object_data.tile_fd = tile_data.fd
			print("tile_id:" .. object_data.tile_id,
				" tile_fv:" .. tostring(object_data.tile_fv) .. " tile_fh:" .. tostring(object_data.tile_fh) .. " tile_fd:" .. tostring(object_data.tile_fd))
			assert(not object_data.tile_fd, "diagonal flip not supported")
		end

		local angle_rad = math.rad(-object.rotation)
		local v_to_center = { x = -object_data.w / 2, y = -object_data.h / 2 }

		-- Not used in that project.
		if (object.text) then
			v_to_center.y = -v_to_center.y --fixed bad texts positions.
		end
		if (object.shape == "rectangle") then
			v_to_center.y = -v_to_center.y --fixed bad texts positions.
		end

		local cosa = math.cos(angle_rad);
		local sina = math.sin(angle_rad);

		local new_v_to_center_x = v_to_center.x * cosa - v_to_center.y * sina
		local new_v_to_center_y = v_to_center.x * sina + v_to_center.y * cosa

		object_data.center_x = object_data.x - new_v_to_center_x
		object_data.center_y = object_data.y - new_v_to_center_y


		--  x' = x*cos(t) - y*sin(t)
		--   y' = x*sin(t) + y*cos(t)

		local tile = TILESETS.by_id[object_data.tile_id]
		if tile then
			setmetatable(object_data.properties, { __index = tile.properties })
		end
		array[i] = object_data
	end
end

local function repack_all(tiled, map)
	for _, l in ipairs(tiled.layers) do
		if l.data then repack_layer(l.data, tiled, map) end
		if l.objects then repack_objects(l.objects, tiled, map) end
	end
end

local function get_layer(tiled, layer_name)
	for _, l in ipairs(tiled.layers) do if l.name == layer_name then return l end end
	return nil
end


--check layer use good tiles.
---@param tilesets LevelTileset[]
local function check_layer_tilesets(layer, tilesets, config)
	config = config or {}
	local no_empty = config.no_empty
	local can_have_collision = config.can_have_collision
	if layer.data then
		for _, tile in ipairs(layer.data) do
			local success = false
			if (tile == 0 and no_empty) then
				assert("bad tile:0")
			else
				success = true
			end

			for _, tileset in ipairs(tilesets) do
				if (tile >= tileset.first_gid and tile <= tileset.end_gid) then
					success = true
					break
				end
			end

			assert(success, "bad tile:" .. tile)
		end
	end

	if layer.objects then
		for _, object in ipairs(layer.objects) do
			local success = false

			if object.tile_id then
				for _, tileset in ipairs(tilesets) do
					if (object.tile_id >= tileset.first_gid and object.tile_id <= tileset.end_gid) then
						success = true
						break
					end
				end
			end
			if can_have_collision and object.properties.collision then
				success = true
			end
			if not success then
				local tile = TILESETS.by_id[object.tile_id]
				pprint(object)
				pprint(tile)
				error("bad object:" .. object.tile_id .. " image:" .. tile.image .. " in layer:" .. layer.name)
			end
			if not success then
				pprint(object)
			end
			assert(success, "bad object:" .. tostring(object.tile_id))
		end
	end
end

local function parse_and_check(layer, tilesets)
	check_layer_tilesets(layer, tilesets)
	local result = {}
	for i, tile in ipairs(layer.data) do
		result[i] = tile
	end

	return result
end

---@param map LevelData
local function parse_level_objects(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["objects"]) })
	assert(layer.objects)
	---@type LevelMapObject[]
	local objects = layer.objects
	for _, obj in ipairs(objects) do
		assert(obj.tile_id, "only tile object supported")
		if (obj.properties.type == "player") then
			assert(not map.player, "player already exist")
			map.player = obj
		else
			pprint(obj)
			error("unknown object")
		end
	end
end

---@param map LevelData
local function parse_visual_objects(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["objects visual"]) })
	assert(layer.objects)
	---@type LevelMapObject[]
	local objects = layer.objects
	for _, obj in ipairs(objects) do
		assert(obj.tile_id, "only tile object supported")
		if (obj.properties.type == "object_visual") then
			table.insert(map.visual_object, obj)
		else
			pprint(obj)
			error("unknown object")
		end
	end
end

---@param map LevelData
---@diagnostic disable-next-line: unused-local
local function parse_geometry(map, layer)
	assert(layer.objects)
	local result = {}
	for _, object in ipairs(layer.objects) do
		assert(not object.tile_id, "not geometry in geometry layer")
		local shape = object.shape
		assert(shape, "should have shape")
		assert(shape == "rectangle" or shape == "polygon" or shape == "ellipse", "support only rectangle, polygon or ellipse")
		assert(object.rotation == 0, "do not support rotation")
		local result_object = { shape = shape, properties = object.properties }
		if (shape == "rectangle") then
			result_object.x, result_object.y = object.x, object.y
			result_object.w, result_object.h = object.w, object.h
		elseif (shape == "polygon") then
			local vertices = {}
			for _, point in ipairs(object.polygon) do
				table.insert(vertices, { point.x, point.y })
			end
			result_object.x = object.x
			result_object.y = object.y
			result_object.vertices = vertices
		elseif (shape == "ellipse") then
			assert(object.w == object.h, "ellipse size not equal.W:" .. object.w .. " H:" .. object.h)
			result_object.x = object.center_x
			result_object.y = object.center_y - object.h
			result_object.radius = object.w / 2
			result_object.shape = "circle"
		end
		table.insert(result, result_object)
	end

	return result
end

local function parse_pathfinding(tiled)
	local layer = get_layer(tiled, "pathfinding")
	local result = { blocked = {} }
	if layer then
		check_layer_tilesets(layer, { assert(TILESETS.tilesets["pathfinding"]) })
		for i, tile in ipairs(layer.data) do
			if tile ~= 0 then
				table.insert(result.blocked, i)
			end
		end
	end
	return result
end

---@param map LevelData
local function check(map)
	assert(map.player, "need player")
end

function M.parse_level(path, result_path)
	local name = path:match("^.+" .. path_symbol .. "(.+)....")
	result_path = result_path .. path_symbol .. name .. ".json"
	local tiled = dofile(path)
	tiled.src = path
	local data = create_map_data(tiled)
	--reorder tileset if level use different order then tilesets.json
	check_tilesets(tiled)
	--change y-down to y-top
	repack_all(tiled, data)
	--convert tiled objects to own format
	for _, l in ipairs(tiled.layers) do
		if l.objects then prepare_objects(l.objects, tiled, data) end
	end

	data.ground = parse_and_check(get_layer(tiled, "ground"), { assert(TILESETS.tilesets["ground"]) })
	data.road = parse_and_check(get_layer(tiled, "road"), { assert(TILESETS.tilesets["roads"]) })

	--parse physics static geometry
	data.geometry = parse_geometry(data, assert(get_layer(tiled, "geometry")))
	data.game_objects = {}
	data.visual_object = {}
	data.pathfinding = parse_pathfinding(tiled)

	-- set parameters to default values
	data.player = nil
	parse_level_objects(data, assert(get_layer(tiled, "objects")))
	parse_visual_objects(data, assert(get_layer(tiled, "objects_visual")))
	--check that data is valid
	check(data)

	--save file
	local json = NEED_PRETTY and pretty(data, nil, "  ", "") or json.encode(data)
	local file = assert(io.open(result_path, "w+"))
	log("save_file:" .. result_path)
	file:write(json)
	file:close()
end

local function CopyFile(old_path, new_path)
	local old_file = io.open(old_path, "rb")
	local new_file = io.open(new_path, "wb")
	local old_file_sz, new_file_sz = 0, 0
	if not old_file then
		return error("no source")
	end
	if not new_file then
		return error("no target")
	end
	while true do
		local block = old_file:read(2 ^ 13)
		if not block then
			old_file_sz = old_file:seek("end")
			break
		end
		new_file:write(block)
	end
	old_file:close()
	new_file_sz = new_file:seek("end")
	new_file:close()
	return assert(new_file_sz == old_file_sz, "bad copy")
end

M.parse = function ()
	parse_tilesets(lfs.currentdir() .. path_symbol .. TILESETS_PATH .. path_symbol .. "tilesets.lua")
	local json = NEED_PRETTY and pretty(TILESETS, nil, "  ", "") or json.encode(TILESETS)
	local file_save = assert(io.open(lfs.currentdir() .. path_symbol .. RESULT_PATH .. path_symbol .. "tileset.json", "w+"))

	file_save:write(json)
	file_save:close()

	for file in lfs.dir(lfs.currentdir() .. path_symbol .. LEVELS_PATH) do
		if file ~= "." and file ~= ".." and file ~= "level_tim_rules.lua" then
			log("parse level:" .. file)
			local status, error_str = pcall(M.parse_level, lfs.currentdir() .. path_symbol .. LEVELS_PATH .. path_symbol .. file,
				lfs.currentdir() .. path_symbol .. RESULT_PATH .. path_symbol)
			if not status then
				log("*********ERROR*********")
				log(file)
				log(error_str)
				log("***********************")
				error(file, error_str)
			end
		end
	end

	--copy to BUNDLE
	for file in lfs.dir(lfs.currentdir() .. path_symbol .. RESULT_PATH) do
		if file ~= "." and file ~= ".." then
			local current_file = lfs.currentdir() .. path_symbol .. RESULT_PATH .. path_symbol .. file

			local name = current_file:match("^.+" .. path_symbol .. "(.+)....")
			local result_file = lfs.currentdir() .. path_symbol .. RES_PATH .. path_symbol .. name .. "json"
			log("copy level:" .. current_file .. "->" .. result_file)
			CopyFile(current_file, result_file)
		end
	end
end

if (not IS_DEFOLD) then
	M.parse()
end

return M
