local INPUT = require "features.core.input.input"

local M = {
	w = 960,
	h = 540
}

local LEFT_MOUSE = hash("touch")
local MIDDLE_MOUSE = hash("mouse_button_middle")
local RIGHT_MOUSE = hash("mouse_button_right")
local WHEEL_UP = hash("scroll_up")
local WHEEL_DOWN = hash("scroll_down")
local TEXT = hash("text")
local KEY_SHIFT = hash("key_shift")
local KEY_CTRL = hash("key_ctrl")
local KEY_ALT = hash("key_alt")
local KEY_SUPER = hash("key_super")

local IMGUI_KEYS = {}
if imgui then
	IMGUI_KEYS = {
		[hash("key_tab")] = imgui.KEY_TAB,
		[hash("key_left")] = imgui.KEY_LEFTARROW,
		[hash("key_right")] = imgui.KEY_RIGHTARROW,
		[hash("key_up")] = imgui.KEY_UPARROW,
		[hash("key_down")] = imgui.KEY_DOWNARROW,
		[hash("key_pageup")] = imgui.KEY_PAGEUP,
		[hash("key_pagedown")] = imgui.KEY_PAGEDOWN,
		[hash("key_home")] = imgui.KEY_HOME,
		[hash("key_end")] = imgui.KEY_END,
		[hash("key_insert")] = imgui.KEY_INSERT,
		[hash("key_delete")] = imgui.KEY_DELETE,
		[hash("key_backspace")] = imgui.KEY_BACKSPACE,
		[hash("key_space")] = imgui.KEY_SPACE,
		[hash("key_enter")] = imgui.KEY_ENTER,
		[hash("key_esc")] = imgui.KEY_ESCAPE,
		[hash("key_numpad_enter")] = imgui.KEY_KEYPADENTER,
		[hash("key_a")] = imgui.KEY_A,
		[hash("key_c")] = imgui.KEY_C,
		[hash("key_v")] = imgui.KEY_V,
		[hash("key_x")] = imgui.KEY_X,
		[hash("key_y")] = imgui.KEY_Y,
		[hash("key_z")] = imgui.KEY_Z,
	}
end

function M:init()
	if not imgui then return end
	local style = {}
	--style.FramePadding = vmath.vector3(1, 1, 0)
	--[[style.ChildBorderSize = 1
	style.PopupRounding = 0
	style.PopupBorderSize = 1

	style.FrameRounding = 0
	style.FrameBorderSize = 0
	style.ItemSpacing = vmath.vector3(8, 4, 0)
	style.ItemInnerSpacing = vmath.vector3(4, 4, 0)
	style.CellPadding = vmath.vector3(4, 2, 0)
	style.TouchExtraPadding = vmath.vector3(0, 0, 0)
	style.IndentSpacing = 21
	style.Alpha = 1
	style.ScrollbarSize = 14
	style.ScrollbarRounding = 9
	style.GrabMinSize = 10
	style.GrabRounding = 0
	style.LogSliderDeadzone = 4
	style.TabRounding = 4
	style.TabBorderSize = 0
	style.TabMinWidthForCloseButton = 0
	style.ColorButtonPosition = 1
	style.ButtonTextAlign = vmath.vector3(0.5, 0.5, 0)
	style.SelectableTextAlign = vmath.vector3(0, 0, 0)
	style.DisplayWindowPadding = vmath.vector3(19, 19, 0)
	style.DisplaySafeAreaPadding = vmath.vector3(3, 3, 0)
	style.MouseCursorScale = 1
	style.CircleSegmentMaxError = 1.6
	style.ColumnsMinSpacing = 6
	style.AntiAliasedLines = true
	style.AntiAliasedLinesUseTex = true
	style.AntiAliasedFill = true
	style.CurveTessellationTol = 1.25
	style.WindowPadding = vmath.vector3(8, 8, 0)
	style.WindowRounding = 0
	style.WindowBorderSize = 1
	style.WindowMinSize = vmath.vector3(32, 32, 0)
	style.WindowTitleAlign = vmath.vector3(0, 0.5, 0)
	style.WindowMenuButtonPosition = 0
	style.ChildRounding = 0--]]
	imgui.set_style(style)

	imgui.set_style_color(imgui.ImGuiCol_Text, 0.90, 0.90, 0.90, 0.90)
	imgui.set_style_color(imgui.ImGuiCol_TextDisabled, 0.60, 0.60, 0.60, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_WindowBg, 0.09, 0.09, 0.15, 0.60)
	imgui.set_style_color(imgui.ImGuiCol_PopupBg, 0.05, 0.05, 0.10, 0.85)
	imgui.set_style_color(imgui.ImGuiCol_Border, 0.70, 0.70, 0.70, 0.65)
	imgui.set_style_color(imgui.ImGuiCol_BorderShadow, 0.00, 0.00, 0.00, 0.00)
	imgui.set_style_color(imgui.ImGuiCol_FrameBg, 0.00, 0.00, 0.01, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_FrameBgHovered, 0.90, 0.80, 0.80, 0.40)
	imgui.set_style_color(imgui.ImGuiCol_FrameBgActive, 0.90, 0.65, 0.65, 0.45)
	imgui.set_style_color(imgui.ImGuiCol_TitleBg, 0.00, 0.00, 0.00, 0.83)
	imgui.set_style_color(imgui.ImGuiCol_TitleBgCollapsed, 0.40, 0.40, 0.80, 0.20)
	imgui.set_style_color(imgui.ImGuiCol_TitleBgActive, 0.00, 0.00, 0.00, 0.87)
	imgui.set_style_color(imgui.ImGuiCol_MenuBarBg, 0.01, 0.01, 0.02, 0.80)
	imgui.set_style_color(imgui.ImGuiCol_ScrollbarBg, 0.20, 0.25, 0.30, 0.60)
	imgui.set_style_color(imgui.ImGuiCol_ScrollbarGrab, 0.55, 0.53, 0.55, 0.51)
	imgui.set_style_color(imgui.ImGuiCol_ScrollbarGrabHovered, 0.56, 0.56, 0.56, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_ScrollbarGrabActive, 0.56, 0.56, 0.56, 0.91)
	imgui.set_style_color(imgui.ImGuiCol_CheckMark, 0.90, 0.90, 0.90, 0.83)
	imgui.set_style_color(imgui.ImGuiCol_SliderGrab, 0.70, 0.70, 0.70, 0.62)
	imgui.set_style_color(imgui.ImGuiCol_SliderGrabActive, 0.30, 0.30, 0.30, 0.84)
	imgui.set_style_color(imgui.ImGuiCol_Button, 0.48, 0.72, 0.89, 0.49)
	imgui.set_style_color(imgui.ImGuiCol_ButtonHovered, 0.50, 0.69, 0.99, 0.68)
	imgui.set_style_color(imgui.ImGuiCol_ButtonActive, 0.80, 0.50, 0.50, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_Header, 0.30, 0.69, 1.00, 0.53)
	imgui.set_style_color(imgui.ImGuiCol_HeaderHovered, 0.44, 0.61, 0.86, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_HeaderActive, 0.38, 0.62, 0.83, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_ResizeGrip, 1.00, 1.00, 1.00, 0.85)
	imgui.set_style_color(imgui.ImGuiCol_ResizeGripHovered, 1.00, 1.00, 1.00, 0.60)
	imgui.set_style_color(imgui.ImGuiCol_ResizeGripActive, 1.00, 1.00, 1.00, 0.90)
	imgui.set_style_color(imgui.ImGuiCol_PlotLines, 1.00, 1.00, 1.00, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_PlotLinesHovered, 0.90, 0.70, 0.00, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_PlotHistogram, 0.90, 0.70, 0.00, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_PlotHistogramHovered, 1.00, 0.60, 0.00, 1.00)
	imgui.set_style_color(imgui.ImGuiCol_TextSelectedBg, 0.00, 0.00, 1.00, 0.35)

	--imgui.scale_all_sizes(1.5)
	--imgui.set_global_font_scale(1.5)

	INPUT.acquire({ on_input =
		function (_, action_id, action)
			local consumed = self:on_input(action_id, action)
			return consumed
		end }, 90)
end

function M:is_imgui_handled_input()
	if not imgui then return false end
	return imgui.want_mouse_input() or imgui.want_keyboard_input() or imgui.want_text_input() or imgui.gizmo_is_using_any()
end

function M:on_input(action_id, action)
	if not imgui then return end
	if action_id == LEFT_MOUSE then
		if action.pressed then
			imgui.set_mouse_button(imgui.MOUSEBUTTON_LEFT, 1)
		elseif action.released then
			imgui.set_mouse_button(imgui.MOUSEBUTTON_LEFT, 0)
		end
	elseif action_id == MIDDLE_MOUSE then
		if action.pressed then
			imgui.set_mouse_button(imgui.MOUSEBUTTON_MIDDLE, 1)
		elseif action.released then
			imgui.set_mouse_button(imgui.MOUSEBUTTON_MIDDLE, 0)
		end
	elseif action_id == RIGHT_MOUSE then
		if action.pressed then
			imgui.set_mouse_button(imgui.MOUSEBUTTON_RIGHT, 1)
		elseif action.released then
			imgui.set_mouse_button(imgui.MOUSEBUTTON_RIGHT, 0)
		end
	elseif action_id == WHEEL_UP then
		imgui.set_mouse_wheel(action.value)
	elseif action_id == WHEEL_DOWN then
		imgui.set_mouse_wheel(-action.value)
	elseif action_id == TEXT then
		imgui.add_input_character(action.text)
	elseif action_id == KEY_SHIFT then
		if action.pressed or action.released then
			imgui.set_key_modifier_shift(action.pressed == true)
		end
	elseif action_id == KEY_CTRL then
		if action.pressed or action.released then
			imgui.set_key_modifier_ctrl(action.pressed == true)
		end
	elseif action_id == KEY_ALT then
		if action.pressed or action.released then
			imgui.set_key_modifier_alt(action.pressed == true)
		end
	elseif action_id == KEY_SUPER then
		if action.pressed or action.released then
			imgui.set_key_modifier_super(action.pressed == true)
		end
	else
		if action.pressed or action.released then
			local key = IMGUI_KEYS[action_id]
			if key then
				--print(action_id,"down:" .. tostring(action.pressed == true), key)
				imgui.set_key_down(key, action.pressed == true)
			end
		end
	end

	if not action_id then
		local x = action.screen_x
		local y = M.h - action.screen_y
		imgui.set_mouse_pos(x, y)
	end
	return M:is_imgui_handled_input()
end

function M.on_resize(w, h)
	if not imgui then return end
	M.w = assert(w)
	M.h = assert(h)
	imgui.set_display_size(w, h)
end

return M
