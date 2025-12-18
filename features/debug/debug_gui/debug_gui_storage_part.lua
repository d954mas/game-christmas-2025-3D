local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class DebugStoragePart:StoragePart
local Storage = CLASS.class("DebugStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.debug_gui = self.storage.data.debug_gui
    if not self.debug_gui then
		self.debug_gui = {
			show = false,
		}
	end
    ---@class Storage
    local storage = self.storage
    storage.debug_gui_storage = self
end

function Storage:is_show()
	return self.debug_gui.show
end


function Storage:set_show(show)
	self.debug_gui.show = show
    self:save()
end


return Storage
