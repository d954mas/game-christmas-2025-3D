local GameMeshReader = require "features.core.mesh_char.game_mesh_reader"

---@class MeshCharFeature:Feature
local M = {}

function M:init()
    GameMeshReader.load()
end

return M