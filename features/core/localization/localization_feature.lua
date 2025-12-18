local LOCALIZATION = require "features.core.localization.localization"
local LocalizationStoragePart = require "features.core.localization.localization_storage_part"


---@class LocalizationFeature:Feature
local M = {
}

function M:on_storage_init(storage)
    self.storage = LocalizationStoragePart.new(storage)
end

function M:late_init()
    LOCALIZATION:init(self.storage:language_get())
end

return M