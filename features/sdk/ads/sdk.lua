local INPUT = require "features.core.input.input"
local LOG = require "libs.log"
local ANALYTICS = require "features.sdk.analytics.analytics"
local SOUNDS = require "features.core.sounds.sounds"
local CONSTANTS = require "libs.constants"
local MockSdk = require "features.sdk.ads.mock_sdk"
local PokiSdk = require "features.sdk.ads.poki_sdk"
local EasyMonetizationSdk = require "features.sdk.ads.easy_monetization_sdk"

local TAG = "SDK"

---@class Sdks
local Sdk = {

}

function Sdk:init()
	self.inited = true
	self.is_poki = poki_sdk
	self.is_easy_monetization = CONSTANTS.TARGET_IS_PLAY_MARKET and yandexads
	self.data = {
		gameplay_start = false,
		gameplay_start_send = false, --gameplay start at least once. PokiSdk can show ads
		interstitial_delay = 180, --for android interstitial
		interstitial_last = socket.gettime()
	}
	self.show_ad = false
	if self.is_poki then
		self.data.interstitial_delay = 0
		self.sdk = PokiSdk.new(self)
	elseif self.is_easy_monetization then
		self.sdk = EasyMonetizationSdk.new(self)
	else
		self.sdk = MockSdk.new(self)
		self.sdk.show_ads = not CONSTANTS.TARGET_IS_PLAY_MARKET
	end
	self.sdk:init()
end

function Sdk:gameplay_start()
	if (not self.data.gameplay_start) then
		LOG.i("gameplay start", TAG)
		self.data.gameplay_start = true
		self.data.gameplay_start_send = true
		ANALYTICS:gameplay_start()
		if self.sdk.gameplay_start then self.sdk:gameplay_start() end
	end
end

function Sdk:gameplay_stop()
	if (self.inited and self.data.gameplay_start) then
		LOG.i("gameplay stop", TAG)
		self.data.gameplay_start = false
		if self.sdk.gameplay_stop then self.sdk:gameplay_stop() end
	end
end

function Sdk:__ads_start()
	SOUNDS:pause()
	INPUT.IGNORE = true
end

function Sdk:__ads_stop()
	SOUNDS:resume()
	INPUT.IGNORE = false
	if html_utils then html_utils.focus() end
end

function Sdk:update(dt)
	if not self.inited then return end
	if self.sdk and self.sdk.update then
		self.sdk:update(dt)
	end
end

function Sdk:ads_rewarded(cb, placement)
	if self.show_ad then
		cb(false)
		return
	end
	self.show_ad = true
	placement = placement or "unknown"
	LOG.i("ads_rewarded:" .. placement, TAG)
	if not self.sdk.internal_log_ads then
		ANALYTICS:ads_start(placement)
	end
	self:__ads_start()
	self.sdk:ads_rewarded(function (success)
		self:__ads_stop()
		if not self.sdk.internal_log_ads then
			ANALYTICS:ads_result(placement, success)
		end
		--add interstitial delay if show rewarded
		if success then self.data.interstitial_last = socket.gettime() end
		cb(success)
		self.show_ad = false
	end, placement)
end

function Sdk:ads_commercial(cb)
	if self.show_ad then
		LOG.i("can't show ads. Ads already shown", TAG)
		cb(false)
		return
	end
	self.show_ad = true
	if (self.data.interstitial_last + self.data.interstitial_delay > socket.gettime()) then
		LOG.i("skip interstitial: " .. (socket.gettime() - self.data.interstitial_last) .. " delay: " .. self.data.interstitial_delay, TAG)
		cb(false)
		self.show_ad = false
		return
	end
	LOG.i("ads_commercial", TAG)
	self.data.interstitial_last = socket.gettime()
	if not self.sdk.internal_log_ads then
		ANALYTICS:ads_start("interstitial")
	end
	self:__ads_start()
	self.sdk:ads_commercial(function (success)
		self:__ads_stop()
		if not self.sdk.internal_log_ads then
			ANALYTICS:ads_result("interstitial", success)
		end
		cb(success)
		self.show_ad = false
	end)
end

return Sdk
