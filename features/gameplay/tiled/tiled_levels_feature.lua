local LEVELS = require "features.gameplay.tiled.levels.levels"
local SM = require "features.core.scenes.scene_manager.scene_manager"
---@class TiledLevelsFeature:Feature
local M = {}

---@param gui_script DebugGuiScript
function M:on_debug_gui_added(gui_script)
    gui_script:add_game_button("Tiled Reload", function ()
        LEVELS.update_tiled()
		--SM:reload(nil, { close_modals = true, use_current_input = true })
    end)
end

return M
