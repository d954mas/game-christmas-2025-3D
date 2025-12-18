local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class DebugStoragePart:StoragePart
local Storage = CLASS.class("DebugStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.debug = self.storage.data.debug
    ---@class Storage
    local storage = self.storage
    storage.debug_gui_storage = self
end

function Storage:is_show()
	return self.debug.show_debug
end


function Storage:set_show(show)
	self.debug.show_debug = show
    self:save()
end


return Storage
