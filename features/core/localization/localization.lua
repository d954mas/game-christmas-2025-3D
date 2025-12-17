local I18N = require "features.core.localization.i18n.init"
local LOG = require "libs.log"
local EVENTS = require "libs.events"

local TAG = "LOCALIZATION"

---@class Localization
local M = {

}


function M:init(locale)
	self.config_all = localization.load_localization_from_resources("/assets/custom/localization_compact.json")
	self.config_tiny = {}
	for k, v in pairs(M.config_all) do
		if k ~= "ko" and k ~= "zh" and k ~= "ja" then
			self.config_tiny[k] = v
		end
	end
	I18N.load(self.config_tiny)

	--I18N.load(LOCALIZATION_LOCAL)
	I18N.setFallbackLocale("en")
	self:set_locale(assert(locale))
end

function M:set_locale(locale)
	LOG.i("set locale:" .. locale, TAG)
	I18N.setLocale(locale)
	EVENTS.LANGUAGE_CHANGED:trigger()
end

function M:locale_get()
	return I18N.getLocale()
end

function M:translate(key, data)
	local translation = I18N.translate(key, data)
	if not translation then
		LOG.e("translation not found:" .. key, TAG)
		return key
	end
	return translation
end

function M:is_exist(id)
	return I18N.translate(id) ~= nil
end

function M:on_font_loaded(font_all)
	LOG.i("on font loaded", TAG)
	self.font_all = assert(font_all)
	I18N.load(self.config_all)
	--add trigger to fix some font not changed it metrics
	timer.delay(0.1, false, function ()
		EVENTS.LANGUAGE_CHANGED:trigger()
	end)
end

return M
