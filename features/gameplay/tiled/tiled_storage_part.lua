local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class TiledStoragePart:StoragePart
local Storage = CLASS.class("TiledStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.debug = self.storage.data.debug
end

function Storage:is_draw_debug_tile_layers()
	return self.debug.draw_debug_tile_layers
end

function Storage:set_draw_debug_tile_layers(draw)
	self.debug.draw_debug_tile_layers = draw
	self:save()
end

return Storage
