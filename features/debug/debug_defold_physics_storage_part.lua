local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class DebugDefoldPhysicsStoragePart:StoragePart
local Storage = CLASS.class("DebugDefoldPhysicsStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.debug = self.storage.data.debug
	if self.debug.draw_physics == nil then
		self.debug.draw_physics = false
	end
end

function Storage:draw_physics_is()
	return self.debug.draw_physics
end

function Storage:draw_physics_set(draw)
	self.debug.draw_physics = draw == true
	self:save()
end

return Storage
