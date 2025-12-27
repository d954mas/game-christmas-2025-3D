local CLASS = require "libs.class"
local INPUT = require "features.core.input.input"
local HASHES = require "libs.hashes"

---#region Storage
local StoragePart = require "features.core.storage.storage_part"

---@class LevelEditor3dStoragePart:StoragePart
local Storage = CLASS.class("LevelEditor3dStoragePart", StoragePart)

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.debug = self.storage.data.debug
	self.editor_visible = false
end

function Storage:is_editor_visible()
	return self.editor_visible
end

function Storage:set_editor_visible(visible)
	self.editor_visible = visible
end

---#endregion

---@class LevelEditor3dFeature:Feature
local Feature = {}

function Feature:init()
	self.subscription = INPUT.acquire(self, 90)
end

function Feature:on_storage_init(storage)
	self.storage = CLASS.new_instance(Storage, storage)
end

function Feature:on_imgui_debug_window()
	if not imgui then return end
	if not self.storage then return end
	local changed, value = imgui.checkbox("Editor Visible", self.storage:is_editor_visible())
	if changed then
		self.storage:set_editor_visible(value)
	end
end

function Feature:on_input(action_id, action)
	if action_id == HASHES.INPUT.EQUALS and action.pressed then
		self.storage:set_editor_visible(not self.storage:is_editor_visible())
		return true
	end
end

return Feature
