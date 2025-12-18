local CONSTANTS = require "libs.constants"
local ConsentStoragePart = require "features.sdk.consent.consent_storage_part"
local SM = require "features.core.scenes.scene_manager.scene_manager"
---@class ConsentFeature:Feature
local M = {}

M.CONSENT_SCENE = "ConsentScene"

function M:init()
    SM:register({
        require "features.sdk.consent.consent.consent_scene".new()
    })
end

function M:on_storage_init(storage)
    self.storage = ConsentStoragePart.new(storage)
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
            SM:show(M.CONSENT_SCENE)
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
