---@class Feature
---@field init fun(self) function to init feature
---@field update fun(self, dt) function to update feature
---@field on_liveupdate_loaded fun(self) function to call when liveupdate is loaded
---@field final fun(self) function to call when feature is removed
---@field on_storage_init fun(self, storage:Storage)
---@field late_init fun(self)
---@field on_resize fun(self, w, h)
---@field on_debug_gui_added fun(self, gui:DebugGuiScript)
---@field on_imgui_debug_window fun(self)


---lifecycle
---init. Storage not available yet
---on_storage_init (StorageFeature:init())
---late_init. Every feature initialized and storage available

local M = {
    ---@type Feature[]
    features = {},
    init_list = {},
    update_list = {},
    on_liveupdate_loaded_list = {},
    final_list = {},
    on_message_list = {},
    on_storage_init_list = {},
    late_init_list = {},
    on_resize_list = {},
    on_debug_gui_added_list = {},
    on_imgui_debug_window_list = {},
    on_game_gui_init_list = {},
    on_game_gui_update_list = {},
    on_game_gui_on_input_list = {},
}

function M:add_feature(feature)
    assert(not self.initialized, "can't add feature after init")
    assert(not self.features[feature], "feature already added")
    self.features[feature] = feature
    if feature.init then table.insert(self.init_list, feature) end
    if feature.update then table.insert(self.update_list, feature) end
    if feature.on_liveupdate_loaded then table.insert(self.on_liveupdate_loaded_list, feature) end
    if feature.final then table.insert(self.final_list, feature) end
    if feature.on_message then table.insert(self.on_message_list, feature) end
    if feature.on_storage_init then table.insert(self.on_storage_init_list, feature) end
    if feature.late_init then table.insert(self.late_init_list, feature) end
    if feature.on_resize then table.insert(self.on_resize_list, feature) end
    if feature.on_debug_gui_added then table.insert(self.on_debug_gui_added_list, feature) end
    if feature.on_imgui_debug_window then table.insert(self.on_imgui_debug_window_list, feature) end
    if feature.on_game_gui_init then table.insert(self.on_game_gui_init_list, feature) end
    if feature.on_game_gui_update then table.insert(self.on_game_gui_update_list, feature) end
    if feature.on_game_gui_on_input then table.insert(self.on_game_gui_on_input_list, feature) end
end

function M:init()
    self.initialized = true
    for i = 1, #self.init_list do
        self.init_list[i]:init()
    end
end

function M:late_init()
    for i = 1, #self.late_init_list do
        self.late_init_list[i]:late_init()
    end
    --on resize is called before loader and feature init
    M:on_resize(RENDER.screen_size.w, RENDER.screen_size.h)
end

function M:update(dt)
    for i = 1, #self.update_list do
        self.update_list[i]:update(dt)
    end
end

function M:on_liveupdate_loaded()
    for i = 1, #self.on_liveupdate_loaded_list do
        self.on_liveupdate_loaded_list[i]:on_liveupdate_loaded()
    end
end

function M:final()
    for i = 1, #self.final_list do
        self.final_list[i]:final()
    end
end

function M:on_message(message_id, message, sender)
    for i = 1, #self.on_message_list do
        self.on_message_list[i]:on_message(message_id, message, sender)
    end
end

---@param storage Storage
function M:on_storage_init(storage)
    for i = 1, #self.on_storage_init_list do
        self.on_storage_init_list[i]:on_storage_init(storage)
    end
end

function M:on_resize(w, h)
    for i = 1, #self.on_resize_list do
        self.on_resize_list[i]:on_resize(w, h)
    end
end

---@param gui DebugGuiScript
function M:on_debug_gui_added(gui)
    for i = 1, #self.on_debug_gui_added_list do
        self.on_debug_gui_added_list[i]:on_debug_gui_added(gui)
    end
end

function M:imgui_debug_window()
    for i = 1, #self.on_imgui_debug_window_list do
        self.on_imgui_debug_window_list[i]:on_imgui_debug_window()
    end
end

---@param gui_script GameSceneGuiScript
function M:on_game_gui_init(gui_script)
    for i = 1, #self.on_game_gui_init_list do
        self.on_game_gui_init_list[i]:on_game_gui_init(gui_script)
    end
end

function M:on_game_gui_update(gui_script, dt)
    for i = 1, #self.on_game_gui_update_list do
        self.on_game_gui_update_list[i]:on_game_gui_update(gui_script, dt)
    end
end

function M:on_game_gui_on_input(gui_script, action_id, action)
    for i = 1, #self.on_game_gui_on_input_list do
        if self.on_game_gui_on_input_list[i]:on_game_gui_on_input(gui_script, action_id, action) then return true end
    end
end

return M
