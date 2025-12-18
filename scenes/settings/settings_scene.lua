local BaseScene = require "features.core.scenes.scene_manager.scene"
local SM_ENUMS = require "features.core.scenes.scene_manager.scene_enums"
local CONTEXTS = require "libs.contexts_manager"
local LUME = require "libs.lume"
local CLASS = require "libs.class"

---@class SettingsScene:Scene
local Scene = CLASS.class("SettingScene", BaseScene)

function Scene.new() return CLASS.new_instance(Scene) end

function Scene:initialize()
	BaseScene.initialize(self, "SettingsScene", "main:/root#scene_settings")
	self._config.modal = true
end

---@async
function Scene:transition(transition)
	if (transition == SM_ENUMS.TRANSITIONS.ON_HIDE) then
		local ctx = CONTEXTS:set_context_top_by_name(CONTEXTS.NAMES.SETTINGS_GUI)
		ctx.data:animate_hide()
		ctx:remove()
		LUME.coroutine_wait(0.2)
	elseif (transition == SM_ENUMS.TRANSITIONS.ON_SHOW) then
		local ctx = CONTEXTS:set_context_top_by_name(CONTEXTS.NAMES.SETTINGS_GUI)
		ctx.data:animate_show()
		ctx:remove()
		LUME.coroutine_wait(0.15)
	end
end

return Scene
