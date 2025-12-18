local CLASS = require "libs.class"
local LUME = require "libs.lume"
local StoragePart = require "features.core.storage.storage_part"

---@class SoundsStoragePart:StoragePart
local SoundsStoragePart = CLASS.class("SoundsStoragePart", StoragePart)

function SoundsStoragePart.new(storage, sounds)
	return CLASS.new_instance(SoundsStoragePart, storage, sounds)
end

---@param storage Storage
---@param sounds Sounds
function SoundsStoragePart:initialize(storage, sounds)
	StoragePart.initialize(self, storage)
    self.SOUNDS = sounds
	self.options = self.storage.data.options
    if not self.options.sound then
		self.options.sound = 0.5
		self.options.music = 0.5
	end
    ---@class Storage
    local storage_local = self.storage
    storage_local.sound_storage = self
    self.SOUNDS:on_music_volume_changed(self.options.music)
    self.SOUNDS:on_sound_volume_changed(self.options.sound)
end

function SoundsStoragePart:sound_set(value)
	self.options.sound = LUME.clamp(value, 0, 1)
    self.SOUNDS:on_sound_volume_changed(self.options.sound)
	self.storage.prev_save_time = math.min(socket.gettime() - self.storage.AUTOSAVE + 3, self.storage.prev_save_time) --force autosave
end

function SoundsStoragePart:sound_get() return self.options.sound end

function SoundsStoragePart:music_set(value)
	self.options.music = LUME.clamp(value, 0, 1)
    self.SOUNDS:on_music_volume_changed(self.options.music)
	self.storage.prev_save_time = math.min(socket.gettime() - self.storage.AUTOSAVE + 3, self.storage.prev_save_time) --force autosave
end

function SoundsStoragePart:music_get() return self.options.music end

return SoundsStoragePart
