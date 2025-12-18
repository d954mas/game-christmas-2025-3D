local CLASS = require "libs.class"
local SM_ENUMS = require "features.core.scenes.scene_manager.scene_enums"
local CONTEXTS = require "libs.contexts_manager"
local LUME = require "libs.lume"
local BaseScene = require "features.core.scenes.scene_manager.scene"

---@class ConsentScene:Scene
local Scene = CLASS.class("ConsentScene", BaseScene)

Scene.CONTEXT_NAME = "CONSENT_GUI"

function Scene.new() return CLASS.new_instance(Scene) end

function Scene:initialize()
	BaseScene.initialize(self, "ConsentScene", "main:/root#scene_consent")
end

---@async
function Scene:transition(transition)
	if (transition == SM_ENUMS.TRANSITIONS.ON_HIDE or
			transition == SM_ENUMS.TRANSITIONS.ON_BACK_HIDE) then
		local ctx = CONTEXTS:set_context_top_by_name(Scene.CONTEXT_NAME)
		ctx.data:animate_hide()
		ctx:remove()
		LUME.coroutine_wait(0.15)
	elseif (transition == SM_ENUMS.TRANSITIONS.ON_SHOW) then
		local ctx = CONTEXTS:set_context_top_by_name(Scene.CONTEXT_NAME)
		ctx.data:animate_show()
		ctx:remove()
		LUME.coroutine_wait(0.15)
	end
end

return Scene
