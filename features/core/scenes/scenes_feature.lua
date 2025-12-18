local SM = require "features.core.scenes.scene_manager.scene_manager"
local SCENE_LOADER = require "features.core.scenes.scene_manager.scene_loader"
local HASH_PROXY_LOADED = hash("proxy_loaded")
local LIVEUPDATE_PROXY_URL = msg.url("main:/root#liveupdate")
local SDK = require "features.sdk.ads.sdk"
local GAME = require "game.game_world"

---@class ScenesFeature:Feature
local M = {
    SCENES = {
        GAME = "GameScene",
    },
    MODALS = {
        SETTINGS = "SettingsScene",
    }
}

---@type Scene[]
local SCENES = {
    require "scenes.game.game_scene",
    require "scenes.settings.settings_scene",
}

function M:init()
    for i = 1, #SCENES do SCENES[i] = SCENES[i].new() end
    SM:register(SCENES)
end

function M:update(dt)
    SM:update(dt)
    local top_scene = SM:get_top()
	if (top_scene and not SM:is_working() and not SDK.show_ad) then
		local scene_name = top_scene._name
		if (scene_name ~= M.SCENES.GAME) then
			SDK:gameplay_stop()
		elseif (GAME.state.first_move) then
			SDK:gameplay_start()
		end
	end
end

function M:on_message(message_id, _, sender)
    if (message_id == HASH_PROXY_LOADED) then
        --ignore liveupdate
        if (sender.fragment ~= LIVEUPDATE_PROXY_URL.fragment) then
            SCENE_LOADER.load_done(sender)
        end
    end
end

return M