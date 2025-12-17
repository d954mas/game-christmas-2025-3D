local STORAGE = require "features.core.storage.storage"
local LOCALIZATION = require "features.core.localization.localization"
local LocalizationStoragePart = require "features.core.localization.localization_storage_part"


---@class LocalizationFeature:Feature
local M = {
}

function M:on_storage_init()
    self.storage = LocalizationStoragePart.new(STORAGE)
end

function M:late_init()
    LOCALIZATION:init(STORAGE.localization_storage:language_get())
end

return M