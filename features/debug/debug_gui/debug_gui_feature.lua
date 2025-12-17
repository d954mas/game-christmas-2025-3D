
---@class DebugGuiFeature:Feature
local DebugGuiFeature = {}

function DebugGuiFeature:on_liveupdate_loaded()
    collectionfactory.create("liveupdate:/root#debug")
end

return DebugGuiFeature