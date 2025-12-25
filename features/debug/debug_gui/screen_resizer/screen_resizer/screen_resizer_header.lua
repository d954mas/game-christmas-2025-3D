---@meta

---@class ScreenResizerSdk
screen_resizer = {}

---Start building a menu. Call before adding items.
function screen_resizer.menu_begin() end

---Add a label entry to the current menu.
---@param id integer unique identifier returned when selected
---@param enabled boolean whether the item can be picked
---@param text string caption to display
function screen_resizer.menu_label(id, enabled, text) end

---Finalize menu construction. Required before showing.
function screen_resizer.menu_finish() end

---Show the menu at the given screen position.
---@param x number screen pixel x
---@param y number screen pixel y
---@return integer selected_id 0 if nothing was picked
function screen_resizer.menu_show(x, y) end

---Sets the game view size and position in screen coordinates.
---@param x? number X position, or nil to center
---@param y? number Y position, or nil to center
---@param width number View width
---@param height number View height
function screen_resizer.set_view_size(x, y, width, height) end

---Gets the game view size and position in screen coordinates.
---@return number x X position
---@return number y Y position
---@return number width View width
---@return number height View height
function screen_resizer.get_view_size() end
