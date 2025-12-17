local LOG = require "libs.log"

---@alias coroutine thread

local lume = {}

local pairs = pairs
local type, assert = type, assert
local tonumber = tonumber
local string_format = string.format
local math_floor = math.floor
local math_ceil = math.ceil
local math_abs = math.abs
local table_remove = table.remove
local math_random = math.random
local math_atan2 = math.atan2
local coroutine_resume = coroutine.resume
local coroutine_yield = coroutine.yield

function lume.clamp(x, min, max) return x < min and min or (x > max and max or x) end

--lume.round(2.3) -- Returns 2
--lume.round(123.4567, .1) -- Returns 123.5
function lume.round(x, increment)
	if increment then return lume.round(x / increment) * increment end
	return x >= 0 and math_floor(x + .5) or math_ceil(x - .5)
end

function lume.sign(x) return x < 0 and -1 or 1 end

function lume.randomchoice(t) return t[math_random(#t)] end

function lume.randomchoice_remove(t) return table_remove(t, math_random(#t)) end

function lume.random(a, b)
	if not a then a, b = 0, 1 end
	if not b then b = 0 end
	return a + math_random() * (b - a)
end

function lume.angle_vector(x, y) return math_atan2(y, x) end

function lume.angle_two_vectors(x1, y1, x2, y2)
	local angle1 = lume.angle_vector(x1, y1)
	local angle2 = lume.angle_vector(x2, y2)
	local angle = angle2 - angle1

	-- Normalize the angle to be within -π to π
	if angle > math.pi then
		angle = angle - 2 * math.pi
	elseif angle < -math.pi then
		angle = angle + 2 * math.pi
	end

	return angle
end

function lume.angle_min_deg(deg)
	deg = deg % 360;
	if (deg < 0) then deg = deg + 360 end
	--if deg > 180 then deg = deg - 360 end
	return deg
end

-- Normalize the angle difference to be between -pi and pi
function lume.normalize_angle(angle)
	return (angle + math.pi) % (2 * math.pi) - math.pi
end

function lume.weightedchoice_nil(t)
	local sum = 0
	for _, v in pairs(t) do
		assert(v >= 0, "weight value less than zero")
		sum = sum + v
	end
	if (sum == 0) then return nil end
	local rnd_init = lume.random(sum)
	local rnd = rnd_init

	local last_value = nil
	for k, v in pairs(t) do
		if rnd < v then
			return k
		end
		last_value = k
		rnd = rnd - v
	end
	return last_value
end

function lume.weightedchoice(t)
	local result = lume.weightedchoice_nil(t)
	if not result then
		error("total weight is zero:" .. json.encode(t))
	end
	return result
end

function lume.removei(t, value)
	for i = 1, #t do
		if t[i] == value then
			return table_remove(t, i)
		end
	end
end

function lume.clearp(t)
	for k, _ in pairs(t) do t[k] = nil end
end

function lume.cleari(t)
	for i = 1, #t do t[i] = nil end
end

function lume.shuffle(t)
	local rtn = {}
	for i = 1, #t do
		local r = math_random(i)
		if r ~= i then
			rtn[i] = rtn[r]
		end
		rtn[r] = t[i]
	end
	return rtn
end

function lume.find(t, value)
	for k, v in pairs(t) do
		if v == value then return k end
	end
	return nil
end

function lume.findi(t, value)
	for i = 1, #t do
		if t[i] == value then return i end
	end
end

---@generic T
---@param t T
---@return T
function lume.clone_shallow(t)
	local rtn = {}
	for k, v in pairs(t) do rtn[k] = v end
	return rtn
end

---@generic T
---@param t T
---@return T
function lume.clone_deep(t)
	local orig_type = type(t)
	---@type any
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, t, nil do
			copy[lume.clone_deep(orig_key)] = lume.clone_deep(orig_value)
		end
	elseif orig_type == 'userdata' then
		if types.is_vector3(t) then
			---@diagnostic disable-next-line: param-type-mismatch
			copy = vmath.vector3(t)
		elseif types.is_vector4(t) then
			---@diagnostic disable-next-line: param-type-mismatch
			copy = vmath.vector4(t)
		elseif types.is_quat(t) then
			---@diagnostic disable-next-line: param-type-mismatch
			copy = vmath.quat(t)
		elseif types.is_matrix4(t) then
			---@diagnostic disable-next-line: param-type-mismatch
			copy = vmath.matrix4(t)
		elseif types.is_hash(t) then
			copy = t
		else
			error("can't clone type:" .. orig_type .. " value:" .. tostring(t))
		end
	else
		copy = t
	end
	return copy
end

function lume.lerp(a, b, amount)
	return a + (b - a) * lume.clamp(amount, 0, 1)
end

function lume.smooth(a, b, amount)
	local t = lume.clamp(amount, 0, 1)
	local m = t * t * (3 - 2 * t)
	return a + (b - a) * m
  end

function lume.color_parse_hexRGBA(hex)
	local r, g, b, a = hex:match("#(%x%x)(%x%x)(%x%x)(%x?%x?)")
	if a == "" then a = "ff" end
	if r and g and b then
		return vmath.vector4(tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255, tonumber(a, 16) / 255)
	end
	error("bad format for hex color:" .. hex)
end

---@param url url
function lume.url_component_from_url(url, component)
	return msg.url(url.socket, url.path, component)
end

function lume.get_human_time(seconds)
	if seconds <= 0 then
		return "00:00";
	else
		local hours = string_format("%02.f", math_floor(seconds / 3600));
		local mins = string_format("%02.f", math_floor(seconds / 60 - (hours * 60)));
		local secs = string_format("%02.f", math_floor(seconds - hours * 3600 - mins * 60));
		if hours == '00' then
			return mins .. ":" .. secs
		else
			return hours .. ":" .. mins .. ":" .. secs
		end
	end
end

local units = { "k", "m", "b", "t" }
-- Function to generate the sequence of units
local function generateAlphabetUnits()
	-- Add single letters A-Z
	for i = 65, 90 do
		-- ASCII values for A-Z
		table.insert(units, string.char(i))
	end

	-- Generate double letters AA, AB, ..., AZ, BA, ..., ZZ
	for i = 65, 90 do
		for j = 65, 90 do
			table.insert(units, string.char(i) .. string.char(j))
		end
	end
end
generateAlphabetUnits() -- Call the function to fill the rest of the unit

---@param num number
---@param precision number|nil
function lume.formatIdleNumber(num, precision)
	local threshold = 99999 -- Set the minimum number to start formatting

	if num <= threshold then
		if precision then
			local decimalPart = num - math_floor(num)
			if decimalPart > 0.05 then
				return string_format("%." .. precision .. "f", num)
			else
				return tostring(num)
			end
		else
			num = math_floor(num)
			return tostring(num)
		end
	end
	num = math_floor(num)

	local logBase1000 = math.log(num) / math.log(1000)
	local unitIndex = math_floor(logBase1000)

	-- Calculate formatted number
	local formattedNum = num / (1000 ^ unitIndex)

	-- Check for boundary condition where formattedNum should transition to the next unit
	if formattedNum >= 1000 and unitIndex < #units then
		unitIndex = unitIndex + 1
		formattedNum = formattedNum / 1000
	end

	-- Manually format the number to include one decimal place
	local integerPart = math_floor(formattedNum)
	local decimalPart = formattedNum - integerPart

	local formattedStr
	if decimalPart == 0 then
		formattedStr = string.format("%d.0%s", integerPart, units[unitIndex])
	else
		-- Ensure only one digit after the decimal point
		local decimalStr = tostring(math_floor(decimalPart * 10))
		formattedStr = tostring(integerPart) .. "." .. decimalStr .. units[unitIndex]
	end

	return formattedStr
end

function lume.equals_float(a, b, epsilon)
	epsilon = epsilon or 0.0001
	return (math_abs(a - b) < epsilon)
end

function lume.merge_table(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				lume.merge_table(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

---@return coroutine|nil return coroutine if it can be resumed(no errors and not dead)
function lume.coroutine_resume(cor, ...)
	local ok, res = coroutine_resume(cor, ...)
	if not ok then
		LOG.w(res .. debug.traceback(cor, "", 1), "Error in coroutine", 1)
	else
		if ((coroutine.status(cor) ~= "dead")) then return cor end
	end
end

---@async
function lume.coroutine_wait(delay)
	while delay > 0 do delay = delay - coroutine_yield() end
end

function lume.split(str, sep)
	if not sep then sep = "%s" end
	local t = {}
	local i = 1
	for s in string.gmatch(str, "([^" .. sep .. "]+)") do
		t[i] = s
		i = i + 1
	end
	return t
end

function lume.get_current_folder()
	local info = sys.get_sys_info({ ignore_secure = true })
	local command

	if info.system_name == "Windows" then
		command = "cd"
	elseif info.system_name == "Darwin" then
		command = "pwd"
	else
		return nil -- Unsupported system
	end

	local handle = io.popen(command)
	if handle then
		local result = handle:read("*a")
		handle:close()
		return result:gsub("[\n\r]", "") -- Remove newline characters from the result
	end
end

function lume.mix_color(output, color1, color2, factor)
	local x = lume.clamp(color1.x * factor + color2.x * (1 - factor), 0, 1)
	local y = lume.clamp(color1.y * factor + color2.y * (1 - factor), 0, 1)
	local z = lume.clamp(color1.z * factor + color2.z * (1 - factor), 0, 1)
	local w = lume.clamp(color1.w * factor + color2.w * (1 - factor), 0, 1)
	xmath.vector4_set_components(output, x, y, z, w)
end

local HASH_DRAW_LINE = hash("draw_line")
local MSD_DRAW_LINE_COLOR = vmath.vector4(1)
local MSD_DRAW_LINE = {
	start_point = vmath.vector3(),
	end_point = vmath.vector3(),
	color = MSD_DRAW_LINE_COLOR
}
function lume.draw_aabb3d(x1, y1, z1, x2, y2, z2, color)
	if color then
		MSD_DRAW_LINE_COLOR.x = color.x
		MSD_DRAW_LINE_COLOR.y = color.y
		MSD_DRAW_LINE_COLOR.z = color.z
		MSD_DRAW_LINE_COLOR.w = color.w
	else
		MSD_DRAW_LINE_COLOR.x = 1
		MSD_DRAW_LINE_COLOR.y = 0
		MSD_DRAW_LINE_COLOR.z = 0
		MSD_DRAW_LINE_COLOR.w = 1
	end

	--bottom
	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x1, y1, z1
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x1, y1, z2
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)

	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x1, y1, z1
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x2, y1, z1
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)

	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x2, y1, z2
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x1, y1, z2
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)

	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x2, y1, z2
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x2, y1, z1
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)

	--top
	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x1, y2, z1
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x1, y2, z2
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)

	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x1, y2, z1
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x2, y2, z1
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)

	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x2, y2, z2
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x1, y2, z2
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)

	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x2, y2, z2
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x2, y2, z1
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)

	--edges

	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x1, y1, z1
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x1, y2, z1
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)
	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x1, y1, z2
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x1, y2, z2
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)
	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x2, y1, z1
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x2, y2, z1
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)
	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x2, y1, z2
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x2, y2, z2
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)
end

function lume.draw_line(x1, y1, z1, x2, y2, z2, color)
	MSD_DRAW_LINE.start_point.x, MSD_DRAW_LINE.start_point.y, MSD_DRAW_LINE.start_point.z = x1, y1, z1
	MSD_DRAW_LINE.end_point.x, MSD_DRAW_LINE.end_point.y, MSD_DRAW_LINE.end_point.z = x2, y2, z2
	MSD_DRAW_LINE.color.x, MSD_DRAW_LINE.color.y, MSD_DRAW_LINE.color.z, MSD_DRAW_LINE.color.w = color.x, color.y, color.z, color.w
	msg.post("@render:", HASH_DRAW_LINE, MSD_DRAW_LINE)
end

local ROMAN_NUMERALS = {
	{1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"},
	{100, "C"}, {90, "XC"}, {50, "L"}, {40, "XL"},
	{10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"}
}
function lume.to_roman(value)
	value = math_floor(value)
	if value <= 0 then return tostring(value) end

	local result = {}
	for i = 1, #ROMAN_NUMERALS do
		local v, s = ROMAN_NUMERALS[i][1], ROMAN_NUMERALS[i][2]
		while value >= v do
			result[#result + 1] = s
			value = value - v
		end
	end
	return table.concat(result)
end

return lume
