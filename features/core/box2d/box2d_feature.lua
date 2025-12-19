local Box2dStoragePart = require "features.core.box2d.box2d_storage_part"

---@class Box2dFeature:Feature
local M = {}


---@param gui_script DebugGuiScript
function M:on_debug_gui_added(gui_script)
    gui_script:add_game_checkbox("Debug Box2d", self.storage:is_draw_debug(), function (checkbox)
        self.storage:set_draw_debug(checkbox.checked)
    end)
end

---@param storage Storage
function M:on_storage_init(storage)
    self.storage = Box2dStoragePart.new(storage)
end

return M
