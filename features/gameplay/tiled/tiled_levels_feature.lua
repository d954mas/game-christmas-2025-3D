local LEVELS = require "features.gameplay.tiled.levels.levels"
---@class TiledLevelsFeature:Feature
local M = {}

function M:init()
    LEVELS:load_tileset()
end

---@param gui_script DebugGuiScript
function M:on_debug_gui_added(gui_script)
    gui_script:add_game_button("Tiled Reload", function ()
        LEVELS.update_tiled()
    end)
end

return M
