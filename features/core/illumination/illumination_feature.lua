local IlluminationStoragePart = require "features.core.illumination.illumination_storage_part"

---@class IlluminationFeature:Feature
local IlluminationFeature = {}

function IlluminationFeature:on_storage_init(storage)
	self.storage = IlluminationStoragePart.new(storage)
end

return IlluminationFeature