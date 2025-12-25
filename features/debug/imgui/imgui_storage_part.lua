local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class ImguiStoragePart:StoragePart
local Storage = CLASS.class("ImguiStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.debug = self.storage.data.debug
end

function Storage:is_show_debug()
	return self.debug.show_imgui_debug
end


function Storage:set_show_debug(show)
	self.debug.show_imgui_debug = show
    self:save()
end


return Storage
