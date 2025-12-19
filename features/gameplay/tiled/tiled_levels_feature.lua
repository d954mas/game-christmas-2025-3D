local LEVELS = require "features.gameplay.tiled.levels.levels"
local CONTEXTS = require "libs.contexts_manager"
local TiledStoragePart = require "features.gameplay.tiled.tiled_storage_part"
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
    gui_script:add_game_checkbox("Tile Debug", self.storage:is_draw_debug_tile_layers(), function (checkbox)
        self.storage:set_draw_debug_tile_layers(checkbox.checked)
    end)
end

---@param storage Storage
function M:on_storage_init(storage)
    self.storage = TiledStoragePart.new(storage)
end

return M
