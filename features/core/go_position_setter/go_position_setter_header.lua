---@meta

---@class NativeGoPositionSetter
go_position_setter = {}

---@return GoPositionSetter
function go_position_setter.new() end

---@class GoPositionSetter
local GoPositionSetter = {}

function GoPositionSetter:add(root, position) end

function GoPositionSetter:remove(root) end

function GoPositionSetter:update() end
