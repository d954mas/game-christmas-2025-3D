local CLASS = require "libs.class"

---@class StoragePart
local Part = CLASS.class("StoragePartBase")

---@param storage Storage
function Part:initialize(storage)
    ---@class Storage
    self.storage = assert(storage)
end

function Part:save(force)
    self.storage:save(force)
end

function Part:changed()
    self.storage:changed()
end

function Part:save_and_changed(force)
    self:save(force)
    self:changed()
end

return Part