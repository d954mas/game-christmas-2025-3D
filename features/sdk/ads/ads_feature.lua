local SDK = require "features.sdk.ads.sdk"

---@class AdsFeature:Feature
local M = {}

function M:update(dt)
    SDK:update(dt)
end

---need consent feature to be ready
function M:late_init()
    SDK:init()
end

return M