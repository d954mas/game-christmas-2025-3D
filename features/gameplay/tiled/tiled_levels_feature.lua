local LEVELS = require "features.gameplay.tiled.levels.levels"
local CONTEXTS = require "libs.contexts_manager"
---@class TiledLevelsFeature:Feature
local M = {}

function M:init()
    LEVELS:load_tileset()
    local ctx = CONTEXTS:set_context_top_render()
    self.tile_layer_predicate = render.predicate({"tile_layer"})
    ctx:remove()
end

---@param gui_script DebugGuiScript
function M:on_debug_gui_added(gui_script)
    gui_script:add_game_button("Tiled Reload", function ()
        LEVELS.update_tiled()
    end)
end

return M
