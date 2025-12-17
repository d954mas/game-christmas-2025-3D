---@meta

---@alias DefosDisplayId string|lightuserdata

---@class DefosDisplayBounds
---@field x number
---@field y number
---@field width number
---@field height number

---@class DefosDisplayMode
---@field width number
---@field height number
---@field bits_per_pixel number
---@field refresh_rate number
---@field scaling_factor number
---@field orientation number
---@field reflect_x boolean
---@field reflect_y boolean

---@class DefosDisplayInfo
---@field id DefosDisplayId
---@field bounds DefosDisplayBounds
---@field mode DefosDisplayMode
---@field name string|nil

---@class DefosCursorHandle: userdata

---@class DefosCursorOptionsMac
---@field image userdata cursor image buffer
---@field hot_spot_x number|nil optional hot spot horizontal offset
---@field hot_spot_y number|nil optional hot spot vertical offset

---@class DefosSdk
defos = {}

-- Window & view -------------------------------------------------------------

---Disable the OS maximize button for the application window.
function defos.disable_maximize_button() end

---Disable the OS minimize button for the application window.
function defos.disable_minimize_button() end

---Disallow resizing the window via the OS chrome.
function defos.disable_window_resize() end

---Set the application window title.
---@param title string
function defos.set_window_title(title) end

---Get the window rectangle in desktop coordinates.
---@return number x
---@return number y
---@return number width
---@return number height
function defos.get_window_size() end

---Set the OS window rectangle. Pass `nil` for `x` or `y` to keep the current position.
---@param x number|nil
---@param y number|nil
---@param width number
---@param height number
function defos.set_window_size(x, y, width, height) end

---Toggle fullscreen mode.
function defos.toggle_fullscreen() end

---Enable or disable fullscreen mode.
---@param enabled boolean
function defos.set_fullscreen(enabled) end

---Check if fullscreen mode is active.
---@return boolean
function defos.is_fullscreen() end

---Toggle the OS "always on top" flag.
function defos.toggle_always_on_top() end

---Enable or disable the "always on top" flag.
---@param enabled boolean
function defos.set_always_on_top(enabled) end

---Check if the window is marked as "always on top".
---@return boolean
function defos.is_always_on_top() end

---Toggle the maximized state.
function defos.toggle_maximize() end

---Toggle the maximized state.
function defos.toggle_maximized() end

---Enable or disable the maximized state.
---@param enabled boolean
function defos.set_maximized(enabled) end

---Check if the window is maximized.
---@return boolean
function defos.is_maximized() end

---Minimize the window.
function defos.minimize() end

---Activate (focus) the window.
function defos.activate() end

---Set the application icon using an image file.
---@param icon_path string
function defos.set_window_icon(icon_path) end

---Get the bundle root path.
---@return string
function defos.get_bundle_root() end

---Get command line or bundle arguments.
---@return string[] arguments
function defos.get_arguments() end

---Alias of `get_arguments`.
---@return string[] arguments
function defos.get_parameters() end

---Get the logical view rectangle in window coordinates.
---@return number x
---@return number y
---@return number width
---@return number height
function defos.get_view_size() end

---Resize the logical view. Pass `nil` for `x` or `y` to keep the current position.
---@param x number|nil
---@param y number|nil
---@param width number
---@param height number
function defos.set_view_size(x, y, width, height) end

-- Console ------------------------------------------------------------------

---Show or hide the Windows console window.
---@param visible boolean
function defos.set_console_visible(visible) end

---Check if the Windows console window is visible.
---@return boolean
function defos.is_console_visible() end

-- Cursor & mouse -----------------------------------------------------------

---Show or hide the OS cursor.
---@param visible boolean
function defos.set_cursor_visible(visible) end

---Check if the OS cursor is visible.
---@return boolean
function defos.is_cursor_visible() end

---Return whether the cursor is within the Defold view.
---@return boolean
function defos.is_mouse_in_view() end

---Get the cursor position in desktop coordinates.
---@return number x
---@return number y
function defos.get_cursor_pos() end

---Get the cursor position relative to the Defold view.
---@return number x
---@return number y
function defos.get_cursor_pos_view() end

---Set the cursor position in desktop coordinates.
---@param x number
---@param y number
function defos.set_cursor_pos(x, y) end

---Set the cursor position relative to the Defold view.
---@param x number
---@param y number
function defos.set_cursor_pos_view(x, y) end

---Alias for `set_cursor_pos_view`.
---@param x number
---@param y number
function defos.move_cursor_to(x, y) end

---Clip the cursor to the Defold view.
---@param clipped boolean
function defos.set_cursor_clipped(clipped) end

---Check if the cursor is clipped to the Defold view.
---@return boolean
function defos.is_cursor_clipped() end

---Lock or unlock the cursor.
---@param locked boolean
function defos.set_cursor_locked(locked) end

---Check if the cursor is locked.
---@return boolean
function defos.is_cursor_locked() end

---@alias DefosCursor integer

---@alias DefosCursorSource string|DefosCursorOptionsMac

---Set the cursor shape.
---@param cursor DefosCursor|DefosCursorHandle|DefosCursorSource|nil
function defos.set_cursor(cursor) end

---Reset to the default cursor.
function defos.reset_cursor() end

---Load a cursor from disk (desktop), image data (macOS) or URL (HTML5).
---@param source DefosCursorSource
---@return DefosCursorHandle cursor
function defos.load_cursor(source) end

-- Displays -----------------------------------------------------------------

---Get information about available displays.
---@return table<integer, DefosDisplayInfo> displays table indexed by order and display id
function defos.get_displays() end

---List all available display modes for the given display.
---@param display_id DefosDisplayId
---@return DefosDisplayMode[] modes
function defos.get_display_modes(display_id) end

---Get the ID of the display that currently hosts the window.
---@return DefosDisplayId
function defos.get_current_display_id() end

-- Events -------------------------------------------------------------------

---Set a callback for mouse enter events (self is the script instance).
---@param callback fun(self:any)|nil
function defos.on_mouse_enter(callback) end

---Set a callback for mouse leave events (self is the script instance).
---@param callback fun(self:any)|nil
function defos.on_mouse_leave(callback) end

---Set a callback for HTML5 click events (self is the script instance).
---@param callback fun(self:any)|nil
function defos.on_click(callback) end

---Set a callback invoked when the cursor lock is disabled (self is the script instance).
---@param callback fun(self:any)|nil
function defos.on_cursor_lock_disabled(callback) end

-- Constants ----------------------------------------------------------------

---@type DefosCursor
defos.CURSOR_ARROW = 0
---@type DefosCursor
defos.CURSOR_CROSSHAIR = 1
---@type DefosCursor
defos.CURSOR_HAND = 2
---@type DefosCursor
defos.CURSOR_IBEAM = 3

---@type string
defos.PATH_SEP = package.config and package.config:sub(1, 1) or "/"
