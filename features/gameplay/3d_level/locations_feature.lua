local LocationsStoragePart = require "features.gameplay.3d_level.locations_storage_part"

---@class LocationsFeature:Feature
local LocationsFeature = {}

function LocationsFeature:on_storage_init(storage)
    self.storage = LocationsStoragePart.new(storage)
end


return LocationsFeature