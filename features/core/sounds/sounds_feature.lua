local SOUNDS = require "features.core.sounds.sounds"
local SoundsStoragePart = require "features.core.sounds.sounds_storage_part"

---@class SoundsFeature:Feature
local M = {}

function M:init()
end

---@param storage Storage
function M:on_storage_init(storage)
    self.storage = SoundsStoragePart.new(storage, SOUNDS)
    local music_gain = self.storage:music_get()
    local sound_gain = self.storage:sound_get()
    --fixed set group gain on init
    timer.delay(0, false, function ()
		SOUNDS:on_music_volume_changed(music_gain)
        SOUNDS:on_sound_volume_changed(sound_gain)
	end)
end

function M:on_liveupdate_loaded()
    SOUNDS:liveupdate_ready()
end

return M