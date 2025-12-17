local STORAGE = require "features.core.storage.storage"

---@class StorageFeature:Feature
local M = {}

function M:init()
    STORAGE:init()
end

function M:update()
   STORAGE:update()
end


return M