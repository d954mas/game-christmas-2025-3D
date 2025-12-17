local CLASS = require "libs.class"
local ANALYTICS = require "features.sdk.analytics.analytics"
local StoragePart = require "features.core.storage.storage_part"


---@class AnalyticsStoragePart:StoragePart
local Storage = CLASS.class("AnalyticsStoragePart", StoragePart)

function Storage.new(storage) return CLASS.new_instance(Storage, storage) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.analytics = self.storage.data.analytics
	if not self.analytics then
		self.analytics = {
			playtime = 0,
			first_play = false
		}
		self.storage.data.analytics = self.analytics
	end

	--try fixed missed events. Mb analytics is still not ready
	timer.delay(0.1, false, function ()
		ANALYTICS:game_loaded()
		self:check_first_play()
	end)
end

function Storage:update(dt)
	self.analytics.playtime = self.analytics.playtime + dt
end

function Storage:check_first_play()
	if not self.analytics.first_play then
		self.analytics.first_play = true
		ANALYTICS:first_play()
		self:save()
	end
end

return Storage
