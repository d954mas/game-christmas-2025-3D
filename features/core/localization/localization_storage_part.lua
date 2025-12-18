local CLASS = require "libs.class"
local CONSTANTS = require "libs.constants"
local LOCALIZATION = require "features.core.localization.localization"
local StoragePart = require "features.core.storage.storage_part"

---@class LocalizationStoragePart:StoragePart
local LocalizationStoragePart = CLASS.class("LocalizationStoragePart", StoragePart)

function LocalizationStoragePart.new(storage)
	return CLASS.new_instance(LocalizationStoragePart, storage)
end

---@param storage Storage
function LocalizationStoragePart:initialize(storage)
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

function LocalizationStoragePart:language_set(value)
	self.localization.language = value
	LOCALIZATION:set_locale(value)
	self:save_and_changed()
end

function LocalizationStoragePart:language_get()
	return self.localization.language
end

return LocalizationStoragePart
