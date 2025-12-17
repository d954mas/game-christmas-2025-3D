---@meta

---@class MnuSdk
mnu = {}

---Start building a menu. Call before adding items.
function mnu.begin() end

---Add a label entry to the current menu.
---@param id integer unique identifier returned when selected
---@param enabled boolean whether the item can be picked
---@param text string caption to display
function mnu.label(id, enabled, text) end

---Insert a visual separator line.
function mnu.separator() end

---Begin a submenu block.
---@param title string submenu caption
function mnu.sub_begin(title) end

---Finish the current submenu block.
function mnu.sub_finish() end

---Finalize menu construction. Required before showing.
function mnu.finish() end

---Show the menu at the given screen position.
---@param x number screen pixel x
---@param y number screen pixel y
---@return integer selected_id 0 if nothing was picked
function mnu.show(x, y) end

---Register a callback that receives submenu selections from the OS app menu.
---@param callback fun(result:integer)
function mnu.show_app_menu(callback) end
