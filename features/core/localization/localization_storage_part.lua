local CLASS = require "libs.class"
local CONSTANTS = require "libs.constants"
local StoragePart = require "features.core.storage.storage_part"

---@class LocalizationStoragePart:StoragePart
local SoundsStoragePart = CLASS.class("LocalizationStoragePart", StoragePart)

function SoundsStoragePart.new(storage)
	return CLASS.new_instance(SoundsStoragePart, storage)
end

---@param storage Storage
function SoundsStoragePart:initialize(storage)
	StoragePart.initialize(self, storage)
	self.localization = self.storage.data.localization
    if not self.localization then
		self.localization = {
			language = CONSTANTS.SYSTEM_INFO.language
		}
		self.storage.data.localization = self.localization
	end
    ---@class Storage
    local storage_local = self.storage
    storage_local.localization_storage = self
end

function SoundsStoragePart:language_set(value)
	self.localization.language = value
	self.storage.prev_save_time = math.min(socket.gettime() - self.storage.AUTOSAVE + 3, self.storage.prev_save_time) --force autosave
end

function SoundsStoragePart:language_get()
	return self.localization.language
end

return SoundsStoragePart
