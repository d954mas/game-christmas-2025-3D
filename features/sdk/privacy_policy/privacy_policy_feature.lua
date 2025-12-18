local SM = require "features.core.scenes.scene_manager.scene_manager"

---@class PrivacyPolicyFeature:Feature
local M = {}

M.PRIVACY_POLICY_SCENE = "PrivacyPolicyScene"

function M:init()
    SM:register({
        require "features.sdk.privacy_policy.privacy_policy_scene".new()
    })
end

return M
