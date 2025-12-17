---@meta

---@class ImGuiSdk
imgui = {}

---Set the ImGui style configuration table.
---@param style table
function imgui.set_style(style) end

---Override a style color.
---@param color_id number one of `imgui.ImGuiCol_*`
---@param r number
---@param g number
---@param b number
---@param a number
function imgui.set_style_color(color_id, r, g, b, a) end

---@return boolean true if ImGui wants mouse input
function imgui.want_mouse_input() end

---@return boolean true if ImGui wants keyboard input
function imgui.want_keyboard_input() end

---@return boolean true if ImGui wants text input
function imgui.want_text_input() end

---@return boolean true if any gizmo is active
function imgui.gizmo_is_using_any() end

---@param button number one of `imgui.MOUSEBUTTON_*`
---@param down boolean|number
function imgui.set_mouse_button(button, down) end

---@param value number wheel delta
function imgui.set_mouse_wheel(value) end

---@param character string
function imgui.add_input_character(character) end

---@param down boolean
function imgui.set_key_modifier_shift(down) end

---@param down boolean
function imgui.set_key_modifier_ctrl(down) end

---@param down boolean
function imgui.set_key_modifier_alt(down) end

---@param down boolean
function imgui.set_key_modifier_super(down) end

---@param key number one of `imgui.KEY_*`
---@param down boolean
function imgui.set_key_down(key, down) end

---@param x number
---@param y number
function imgui.set_mouse_pos(x, y) end

---@param width number
---@param height number
function imgui.set_display_size(width, height) end

---@type number
imgui.KEY_TAB = 0
---@type number
imgui.KEY_LEFTARROW = 0
---@type number
imgui.KEY_RIGHTARROW = 0
---@type number
imgui.KEY_UPARROW = 0
---@type number
imgui.KEY_DOWNARROW = 0
---@type number
imgui.KEY_PAGEUP = 0
---@type number
imgui.KEY_PAGEDOWN = 0
---@type number
imgui.KEY_HOME = 0
---@type number
imgui.KEY_END = 0
---@type number
imgui.KEY_INSERT = 0
---@type number
imgui.KEY_DELETE = 0
---@type number
imgui.KEY_BACKSPACE = 0
---@type number
imgui.KEY_SPACE = 0
---@type number
imgui.KEY_ENTER = 0
---@type number
imgui.KEY_ESCAPE = 0
---@type number
imgui.KEY_KEYPADENTER = 0
---@type number
imgui.KEY_A = 0
---@type number
imgui.KEY_C = 0
---@type number
imgui.KEY_V = 0
---@type number
imgui.KEY_X = 0
---@type number
imgui.KEY_Y = 0
---@type number
imgui.KEY_Z = 0

---@type number
imgui.MOUSEBUTTON_LEFT = 0
---@type number
imgui.MOUSEBUTTON_MIDDLE = 1
---@type number
imgui.MOUSEBUTTON_RIGHT = 2

---@type number
imgui.ImGuiCol_Text = 0
---@type number
imgui.ImGuiCol_TextDisabled = 0
---@type number
imgui.ImGuiCol_WindowBg = 0
---@type number
imgui.ImGuiCol_PopupBg = 0
---@type number
imgui.ImGuiCol_Border = 0
---@type number
imgui.ImGuiCol_BorderShadow = 0
---@type number
imgui.ImGuiCol_FrameBg = 0
---@type number
imgui.ImGuiCol_FrameBgHovered = 0
---@type number
imgui.ImGuiCol_FrameBgActive = 0
---@type number
imgui.ImGuiCol_TitleBg = 0
---@type number
imgui.ImGuiCol_TitleBgCollapsed = 0
---@type number
imgui.ImGuiCol_TitleBgActive = 0
---@type number
imgui.ImGuiCol_MenuBarBg = 0
---@type number
imgui.ImGuiCol_ScrollbarBg = 0
---@type number
imgui.ImGuiCol_ScrollbarGrab = 0
---@type number
imgui.ImGuiCol_ScrollbarGrabHovered = 0
---@type number
imgui.ImGuiCol_ScrollbarGrabActive = 0
---@type number
imgui.ImGuiCol_CheckMark = 0
---@type number
imgui.ImGuiCol_SliderGrab = 0
---@type number
imgui.ImGuiCol_SliderGrabActive = 0
---@type number
imgui.ImGuiCol_Button = 0
---@type number
imgui.ImGuiCol_ButtonHovered = 0
---@type number
imgui.ImGuiCol_ButtonActive = 0
---@type number
imgui.ImGuiCol_Header = 0
---@type number
imgui.ImGuiCol_HeaderHovered = 0
---@type number
imgui.ImGuiCol_HeaderActive = 0
---@type number
imgui.ImGuiCol_ResizeGrip = 0
---@type number
imgui.ImGuiCol_ResizeGripHovered = 0
---@type number
imgui.ImGuiCol_ResizeGripActive = 0
---@type number
imgui.ImGuiCol_PlotLines = 0
---@type number
imgui.ImGuiCol_PlotLinesHovered = 0
---@type number
imgui.ImGuiCol_PlotHistogram = 0
---@type number
imgui.ImGuiCol_PlotHistogramHovered = 0
---@type number
imgui.ImGuiCol_TextSelectedBg = 0
