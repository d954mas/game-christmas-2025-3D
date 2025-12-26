local StoragePart = require "features.meta.skins.skins3d_storage_part"

---@class SkinFeature:Feature
local SkinFeature = {}

function SkinFeature:on_storage_init(storage)
    self.storage = StoragePart.new(storage)
end

return SkinFeature