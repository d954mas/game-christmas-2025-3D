local ANALYTICS = require "features.sdk.analytics.analytics"
local STORAGE = require "features.core.storage.storage"
local AnalyticsStoragePart = require "features.sdk.analytics.analytics_storage_part"

---@class AnalyticsFeature:Feature
local M = {}

function M:init()
    ANALYTICS:init()
end

function M:update(dt)
   if self.storage then
       self.storage:update(dt)
   end
end

function M:on_storage_init()
    self.storage = AnalyticsStoragePart.new(STORAGE)
end

return M