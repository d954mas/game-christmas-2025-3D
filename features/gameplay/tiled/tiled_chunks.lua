local BALANCE = require "game.balance"

local M = {}

function M.iterate(level_width, level_height, callback)
	local chunk_size = BALANCE.config.TILE_CHUNK_SIZE
	local column_size = assert(chunk_size.w)
	local row_size = assert(chunk_size.h)
	assert(column_size > 0 and row_size > 0, "TILE_CHUNK_SIZE must be positive")

	local y = 0
	while y < level_height do
		local y2 = math.min(y + row_size - 1, level_height - 1)
		local x = 0
		while x < level_width do
			local x2 = math.min(x + column_size - 1, level_width - 1)
			callback(x, y, x2, y2)
			x = x + column_size
		end
		y = y + row_size
	end
end

return M
