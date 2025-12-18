local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class DebugEcsStoragePart:StoragePart
local Storage = CLASS.class("DebugEcsStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.debug = self.storage.data.debug
    ---@class Storage
    local storage = self.storage
    storage.debug_ecs_storage = self
end

function Storage:is_show()
	return self.debug.show_ecs
end


function Storage:set_show(show)
	self.debug.show_ecs = show
    self:save()
end


return Storage
