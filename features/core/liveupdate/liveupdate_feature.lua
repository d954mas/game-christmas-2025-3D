local LIVEUPDATE = require "features.core.liveupdate.liveupdate"
local HASH_PROXY_LOADED = hash("proxy_loaded")
local LIVEUPDATE_PROXY_URL = msg.url("main:/root#liveupdate")
---@class LiveUpdateFeature:Feature
local M = {}

function M:init()
    LIVEUPDATE.load(function () msg.post(LIVEUPDATE_PROXY_URL, "async_load") end)
end

function M:on_message(message_id, _, sender)
    if (message_id == HASH_PROXY_LOADED) then
        --ignore liveupdate
        if (sender.fragment == LIVEUPDATE_PROXY_URL.fragment) then
            msg.post(sender, "enable")
        end
    end
end

return M
