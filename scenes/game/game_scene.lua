local BaseScene = require "features.core.scenes.scene_manager.scene"
local CLASS = require "libs.class"

---@class GameScene:Scene
local Scene = CLASS.class("GameScene", BaseScene)

function Scene.new()
	return CLASS.new_instance(Scene)
end

function Scene:initialize()
	BaseScene.initialize(self, "GameScene", "main:/root#scene_game")
	self._config.keep_running = true
end

function Scene:on_resume_done()
end

return Scene