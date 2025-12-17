local STORAGE = require "features.core.storage.storage"
local CONSTANTS = require "libs.constants"
local ConsentStoragePart = require "features.sdk.consent.consent_storage_part"

---@class ConsentFeature:Feature
local M = {}

function M:on_storage_init()
    self.storage = ConsentStoragePart.new(STORAGE)
end

function M:check_consent(cb)
    if not self.storage:is_show() then
        local need_show_consent = CONSTANTS.TARGET_IS_PLAY_MARKET
        local code = CONSTANTS.SYSTEM_INFO.language

        local no_gdpr_languages = {
            ru = true,
            az = true,
            hy = true,
            be = true,
            uz = true,
            kk = true,
            ky = true,
            tk = true,
            tg = true,
            uk = true
        }
        --print("is no_gdpr_languages:", no_gdpr_languages[code])
        need_show_consent = need_show_consent and not no_gdpr_languages[code]
        --print("language:" .. code, "need show:", tostring(need_show_consent))
        if need_show_consent then
            --SM:show(SM.SCENES.CONSENT)
            --show consent scene
        else
            self.storage:accept()
            cb()
        end
    else
        cb()
    end
end

return M
