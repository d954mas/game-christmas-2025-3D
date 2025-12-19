local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class Box2dStoragePart:StoragePart
local Storage = CLASS.class("Box2dStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.debug = self.storage.data.debug
end

function Storage:is_draw_debug()
	return self.debug.box2d_draw_debug
end


function Storage:set_draw_debug(draw)
	self.debug.box2d_draw_debug = draw
    self:save()
end


return Storage
