local CLASS = require "libs.class"
local BUTTON = require "libs.gui.button"

---@class DebugCheckbox:Button
local DebugCheckbox = CLASS.class("DebugCheckbox", BUTTON)

function DebugCheckbox.new(template_name)
    return CLASS.new_instance(DebugCheckbox, gui.get_node(template_name .. "/root"),
        gui.get_node(template_name .. "/checked"))
end

function DebugCheckbox:initialize(root_node, checked_node)
    self.checked_node = checked_node
    BUTTON.initialize(self, root_node)
end

function DebugCheckbox:refresh_view()
    gui.set_enabled(self.checked_node, self.checked)
end

return DebugCheckbox
