local CLASS = require "libs.class"

---@class DynamicZ
local DynamicZ = CLASS.class("DynamicZ")

---@return DynamicZ
function DynamicZ.new(y1,y2,z1,z2)
    return CLASS.new_instance(DynamicZ, y1,y2,z1,z2)
end

function DynamicZ:initialize(y1,y2,z1,z2)
    self.y1 = y1
    self.y2 = y2
    self.z1 = z1
    self.z2 = z2
    self.z_per_y = (z2 - z1) / (y2 -y1)
end

function DynamicZ:count_z_pos(y, dz)
    return self.z2 - (y - self.y1) * self.z_per_y + (dz or 0)
end

return DynamicZ
