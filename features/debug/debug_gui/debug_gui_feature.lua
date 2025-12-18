local DebugGuiStoragePart = require "features.debug.debug_gui.debug_gui_storage_part"

---@class DebugGuiFeature:Feature
local DebugGuiFeature = {}

function DebugGuiFeature:on_liveupdate_loaded()
    collectionfactory.create("liveupdate:/root#debug")
end

---@param storage Storage
function DebugGuiFeature:on_storage_init(storage)
    self.storage = DebugGuiStoragePart.new(storage)
end

return DebugGuiFeature