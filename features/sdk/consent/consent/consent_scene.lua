local CLASS = require "libs.class"
local SM_ENUMS = require "libs.sm.scene_enums"
local CONTEXTS = require "libs.contexts_manager"
local LUME = require "libs.lume"
local BaseScene = require "libs.sm.scene"

---@class ConsentScene:Scene
local Scene = CLASS.class("ConsentScene", BaseScene)

function Scene.new() return CLASS.new_instance(Scene) end

function Scene:initialize()
	BaseScene.initialize(self, "ConsentScene", "main:/root#scene_consent")
end

---@async
function Scene:transition(transition)
	if (transition == SM_ENUMS.TRANSITIONS.ON_HIDE or
			transition == SM_ENUMS.TRANSITIONS.ON_BACK_HIDE) then
		local ctx = CONTEXTS:set_context_top_by_name(CONTEXTS.NAMES.CONSENT_GUI)
		ctx.data:animate_hide()
		ctx:remove()
		LUME.coroutine_wait(0.15)
	elseif (transition == SM_ENUMS.TRANSITIONS.ON_SHOW) then
		local ctx = CONTEXTS:set_context_top_by_name(CONTEXTS.NAMES.CONSENT_GUI)
		ctx.data:animate_show()
		ctx:remove()
		LUME.coroutine_wait(0.15)
	end
end

return Scene
