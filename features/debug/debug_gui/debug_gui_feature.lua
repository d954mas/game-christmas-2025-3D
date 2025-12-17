local DebugGuiStoragePart = require "features.debug.debug_gui.debug_gui_storage_part"
local STORAGE = require "features.core.storage.storage"
---@class DebugGuiFeature:Feature
local DebugGuiFeature = {}

function DebugGuiFeature:on_liveupdate_loaded()
    collectionfactory.create("liveupdate:/root#debug")
end

function DebugGuiFeature:on_storage_init()
    self.storage = DebugGuiStoragePart.new(STORAGE)
    ---@class Storage
    local storage = STORAGE
    storage.debug_gui_storage = self.storage
end

return DebugGuiFeature