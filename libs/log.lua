local _print = print
local ERROR_CACHE = {}

---@class Log
---@field ANALYTICS Analytics
local M = {}

M.blacklist = {
	list = {
		["Sound"] = true,
	}
}

M.INFO = { name = "INFO", priority = 1 }
M.WARNING = { name = "WARNING", priority = 2 }
M.ERROR = { name = "ERROR", priority = 3 }


local function save_log_line(line, level, tag, debug_level)
	if line == nil then return end

	line = tostring(line)
	level = level or M.INFO
	tag = tag or ""
	debug_level = debug_level or 0

	if M.blacklist.list[tag] then return end

	local timestamp = os.time()
	local timestamp_string = os.date('%H:%M:%S', timestamp)

	local head = "[" .. level.name .. timestamp_string .. "]"
	local body = ""

	head = head .. " " .. tag .. ":"

	if debug then
		local info = debug.getinfo(3 + debug_level, "Sl") -- https://www.lua.org/pil/23.1.html
		local short_src = info.short_src
		local line_number = info.currentline
		body = short_src .. ":" .. line_number .. ":"
	end

	local complete_line = head .. " " .. body .. " " .. line
	if level.priority >= M.WARNING.priority then
		local error_head = "[" .. level.name .. "]"
		error_head = error_head .. " " .. tag .. ":"
		local error_line = error_head .. " " .. body .. " " .. line
		if not ERROR_CACHE[error_line] or socket.gettime() - ERROR_CACHE[error_line] > 60 then
			ERROR_CACHE[error_line] = socket.gettime()
			--_print("send error:", error_line)
			if poki_sdk then poki_sdk.capture_error(error_line) end
			if M.ANALYTICS then M.ANALYTICS:error(error_line) end
		end
	end
	_print(complete_line)
end

function M.w(message, tag, debug_level)
	save_log_line(message, M.WARNING, tag, debug_level)
end

function M.e(message, tag, debug_level)
	save_log_line(message, M.ERROR, tag, debug_level)
end

--#IF RELEASE
---@diagnostic disable-next-line: duplicate-set-field
function M.i() end

--#ELSE
---@diagnostic disable-next-line: duplicate-set-field
function M.i(message, tag, debug_level)
	save_log_line(message, M.INFO, tag, debug_level)
end

--override print
print = function (...)
	local arg = { ... }
	local result = tostring(arg[1])
	for i = 2, #arg do
		result = result .. "\t" .. tostring(arg[i])
	end
	M.i(result, nil, 1)
end
--#ENDIF


return M
