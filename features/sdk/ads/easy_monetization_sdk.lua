local CLASS = require "libs.class"
local CONSTANTS = require "libs.constants"
local CONTEXT = require "libs.contexts_manager"
local ANALYTICS = require "features.sdk.analytics.analytics"
local STORAGE = require "features.core.storage.storage"
local LOG = require "libs.log"
local TAG = "EASYMONETIZATION"

local Sdk = CLASS.class("EasyMonetizationSdk")

function Sdk.new(sdks) return CLASS.new_instance(Sdk, sdks) end

---@param sdks Sdks
function Sdk:initialize(sdks)
	self.sdks = assert(sdks)
	self.callback = nil
	self.context = nil
	self.initialized = false
	self.rewarded = {
		name = "unknown",
		success = false
	}
	self.config = {
	}

	self.banner = {
		loading = false,
		load_attempts = 0,
		need_show = true,
		show = false
	}

	self.internal_log_ads = true


	self.ads = CONSTANTS.VERSION_IS_RELEASE and CONSTANTS.EASYMONETIZATION.RELEASE or
		CONSTANTS.EASYMONETIZATION.TEST

	self.msg_id_to_string = {
		[yandexads.MSG_ADS_INITED] = "MSG_ADS_INITED",
		[yandexads.MSG_INTERSTITIAL] = "MSG_INTERSTITIAL",
		[yandexads.MSG_REWARDED] = "MSG_REWARDED",
		[yandexads.MSG_BANNER] = "MSG_BANNER",
	}
	self.msg_to_string = {
		[yandexads.EVENT_LOADED] = "EVENT_LOADED",
		[yandexads.EVENT_ERROR_LOAD] = "EVENT_ERROR_LOAD",
		[yandexads.EVENT_SHOWN] = "EVENT_SHOWN",
		[yandexads.EVENT_DISMISSED] = "EVENT_DISMISSED",
		[yandexads.EVENT_CLICKED] = "EVENT_CLICKED",
		[yandexads.EVENT_IMPRESSION] = "EVENT_IMPRESSION",
		[yandexads.EVENT_NOT_LOADED] = "EVENT_NOT_LOADED",
		[yandexads.EVENT_REWARDED] = "EVENT_REWARDED",
		[yandexads.EVENT_DESTROYED] = "EVENT_DESTROYED",
	}
end

function Sdk:interstitial_load()
	if (not yandexads.is_interstitial_loaded()) then
		yandexads.load_interstitial(self.ads.interstitial)
	end
end

function Sdk:rewarded_load()
	if (not yandexads.is_rewarded_loaded()) then
		yandexads.load_rewarded(self.ads.rewarded)
	end
end

function Sdk:banner_load()
	if self.banner.loading then return end
	if (not yandexads.is_banner_loaded()) then
		self.banner.load_attempts = self.banner.load_attempts + 1
		self.banner.loading = true
		self.banner.width = RENDER.screen_size.w
		yandexads.load_banner(self.ads.banner)
	end
end

function Sdk:update(_)
	if not CONTEXT:exist(CONTEXT.NAMES.GAME_GUI) then return end
	if not self.initialized then return end
	--[[if not self.banner.loading and yandexads.is_banner_loaded() then
		if COMMON.RENDER.screen_size.w ~= self.banner.width then
			yandexads.destroy_banner()
			self.banner.loading = true
		end
	end--]]

	local need_show_banner = false
	self.banner.need_show = need_show_banner

	if yandexads.is_banner_loaded() then
		if self.banner.need_show and not self.banner.show then
			self.banner.show = true
			yandexads.show_banner(yandexads.POS_BOTTOM_CENTER) -- position: int
		end
		if not self.banner.need_show and self.banner.show then
			self.banner.show = false
			yandexads.hide_banner()
		end
	end
end

function Sdk:on_message(_, message_id, message)
	local event = message.event
	LOG.i(self.msg_id_to_string[message_id] .. " " .. self.msg_to_string[event], TAG)
	pprint(message)
	if message_id == yandexads.MSG_ADS_INITED then
		self.initialized = true
		self:interstitial_load()
		self:rewarded_load()
		self:banner_load()
	end

	if message_id == yandexads.MSG_INTERSTITIAL then
		if event == yandexads.EVENT_SHOWN then
			self:pause()
		elseif event == yandexads.EVENT_DISMISSED then
			self:resume()
			ANALYTICS:ads_result("interstitial", true)
			self:callback_execute(true)
			self:interstitial_load()
		elseif event == yandexads.EVENT_FAILED_TO_SHOW then
			self:resume()
			ANALYTICS:ads_result("interstitial", false)
			self:callback_execute(false)
		elseif event == yandexads.EVENT_IMPRESSION then
			ANALYTICS:event_ads_revenue_yandex("interstitial", message.data)
		end
	end

	if message_id == yandexads.MSG_REWARDED then
		if event == yandexads.EVENT_SHOWN then

		elseif event == yandexads.EVENT_DISMISSED then
			self:resume()
			ANALYTICS:ads_result(self.rewarded.name, self.rewarded.success)
			self:callback_execute(self.rewarded.success)
			self:rewarded_load()
		elseif event == yandexads.EVENT_FAILED_TO_SHOW then
			ANALYTICS:ads_result(self.rewarded.name, false)
			self:callback_execute(false)
			if android_toast then
				android_toast.toast("Rewarded AD failed to show", 1)
			end
		elseif event == yandexads.EVENT_REWARDED then
			self.rewarded.success = true
		elseif event == yandexads.EVENT_IMPRESSION then
			ANALYTICS:event_ads_revenue_yandex("rewarded", message.data)
		end
	end

	if message_id == yandexads.MSG_BANNER then
		if event == yandexads.EVENT_LOADED then
			self.banner.load_attempts = 0
			self.banner.loading = false
			--yandexads.show_banner(yandexads.BOTTOM_CENTER) -- optional position(default BOTTOM_CENTER)
		elseif event == yandexads.EVENT_ERROR_LOAD then
			local delay = 5
			if self.banner.load_attempts <= 1 then
				delay = 30
			elseif self.banner.load_attempts <= 3 then
				delay = 120
			elseif self.banner.load_attempts <= 5 then
				delay = 600
			end
			local ctx = CONTEXT:set_context_top_loader()
			timer.delay(delay, false, function ()
				self:banner_load()
			end)
			ctx:remove()
		elseif event == yandexads.EVENT_DESTROYED then
			self.banner.loading = false
			self.banner.load_attempts = 0
			self:banner_load()
			self.banner.show = false
		elseif event == yandexads.EVENT_IMPRESSION then
			ANALYTICS:event_ads_revenue_yandex("banner", message.data)
		end
	end
end

function Sdk:callback_save(cb)
	assert(not self.callback)
	self.callback = cb
	self.context = lua_script_instance.Get()
end

function Sdk:callback_execute(...)
	if (self.callback) then
		local ctx = CONTEXT:set_context_top_by_instance(self.context)
		self.callback(...)
		ctx:remove()
		self.context = nil
		self.callback = nil
	else
		LOG.w("no callback to execute", TAG)
	end
end

function Sdk:pause()
	self.sdks:__ads_start()
end

function Sdk:resume()
	self.sdks:__ads_stop()
end

function Sdk:init()
	LOG.i("init ", TAG)
	yandexads.set_callback(function (...)
		self:on_message(...)
	end)
	yandexads.set_user_consent(STORAGE.consent_storage:is_accepted()) -- consent: boolean
	if CONSTANTS.VERSION_IS_DEV then
		yandexads.enable_logging()
	end
	yandexads.initialize()
end

function Sdk:ads_commercial(cb)
	LOG.i("interstitial_ad show", TAG)
	if (not self.initialized) then
		LOG.w("can't show ads. Not initialized")
		cb(false)
		return
	end
	if (self.callback) then
		LOG.w("Interstitial. can't show already have callback")
		if (cb) then cb(false) end
		return
	else
		ANALYTICS:ads_start("interstitial") -- need send ads here
		if (yandexads.is_interstitial_loaded()) then
			LOG.i("show inter",TAG)
			self:callback_save(cb)
			self:pause()
			yandexads.show_interstitial()
		else
			LOG.i("load inter",TAG)
			self:interstitial_load()
			cb(false)
			ANALYTICS:ads_result("interstitial", false)
		end
	end
end

function Sdk:ads_rewarded(cb, name)
	LOG.i("rewarded_ad show", TAG)
	if (not self.initialized) then
		LOG.w("can't show ads. Not initialized")
		if (cb) then cb(false, "not inited") end
		return
	end
	if (self.callback) then
		LOG.w("Rewarded. Can't show already have callback")
		if (cb) then cb(false, "callback exist") end
		return
	else
		self.rewarded.name = tostring(name)
		self.rewarded.success = false
		ANALYTICS:ads_start(self.rewarded.name)
		if (yandexads.is_rewarded_loaded()) then
			self:pause()
			self:callback_save(cb)
			yandexads.show_rewarded()
		else
			self:rewarded_load()
			ANALYTICS:ads_result(self.rewarded.name, false)
			cb(false)
			if android_toast then
				android_toast.toast("Rewarded AD not loaded.Please, try later", 1)
			end
		end
	end
end

return Sdk
