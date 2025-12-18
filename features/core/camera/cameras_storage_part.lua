local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class CamerasStoragePart:StoragePart
local Storage = CLASS.class("CamerasStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.options = self.storage.data.options
    if not self.options.camera_zoom then
        self.options.camera_zoom = 0.5
    end
    ---@class Storage
    local storage = self.storage
    storage.cameras_storage = self
end

function Storage:get_zoom()
	return self.options.camera_zoom
end


function Storage:set_zoom(zoom)
	self.options.camera_zoom = zoom
end


return Storage
