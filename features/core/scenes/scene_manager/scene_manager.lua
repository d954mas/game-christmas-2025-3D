local SCENE_ENUMS = require "features.core.scenes.scene_manager.scene_enums"
local CHECKS = require "libs.checks"
local LUME = require "libs.lume"
local LOG = require "libs.log"
local SceneStack = require "features.core.scenes.scene_manager.scene_stack"

local TAG = "SceneManager"

local CHECKS_SHOW = {
	reload = "?boolean", --if scene already in top reload it
	close_modals = "?boolean",
	delay = "?number"
}
local CHECKS_RELOAD = {
	use_current_input = "?boolean",
	close_modals = "?boolean"
}
local CHECKS_REPLACE = {
	--    reload = "?boolean", --if scene already in top reload it
	close_modals = "?boolean", --close_modals
}
local CHECKS_UNLOAD = {
	new_scene = "?class:Scene",
	skip_transition = "?boolean",
	keep_show = "?boolean",
}


local M = {
	stack = SceneStack.new(),
	---@type Scene[]
	scenes = {},
	co = nil,
}

---@param scenes Scene[]
function M:register(scenes)
	--assert(#self.scenes == 0, "register_scenes can be called only once")
	assert(scenes, "scenes can't be nil")
	assert(#scenes ~= 0, "scenes should have one or more scene")
	for _, scene in ipairs(scenes) do
		assert(scene._name, "scene name can't be nil")
		assert(not self.scenes[scene._name], "scene:" .. scene._name .. " already exist")
		self.scenes[scene._name] = scene
	end
end

function M:is_working() return self.co end

function M:update(dt)
	if self.co then self.co = LUME.coroutine_resume(self.co, dt) end
end

---@param input nil|table
function M:show(name, input, options)
	CHECKS("?", "string", "?", CHECKS_SHOW)
	assert(not self:is_working())
	options = options or {}
	local new_scene = assert(self.scenes[name], "unknown scene:" .. name)
	if (new_scene == self.stack:peek() and options.reload) then
		self:reload(input)
	else
		self.co = coroutine.create(function () ---@async
			if (options.delay) then
				LUME.coroutine_wait(options.delay)
			end
			if (options.close_modals) then
				self:_close_modals_f()
			end
			self:_show_scene_f(new_scene, input)
		end)
		self:update(0)
	end
end

function M:reload(input, options)
	CHECKS("?", "?", CHECKS_RELOAD)
	options = options or {}
	assert(not self:is_working())
	self.co = coroutine.create(function () ---@async
		if (options.close_modals) then
			self:_close_modals_f()
			local scene = self.stack:peek()
			if (scene._state == SCENE_ENUMS.STATES.PAUSED) then scene:resume() end
		end
		local scene = self.stack:peek()
		if (options.use_current_input) then input = scene._input end
		self:_unload_scene_f(scene)
		self.stack:pop()
		self:_show_scene_f(scene, input)
	end)
	self:update(0)
end

function M:replace(name, input, options)
	CHECKS("?", "string", "?", CHECKS_REPLACE)
	options = options or {}
	assert(not self:is_working())

	local new_scene = assert(self.scenes[name], "unknown scene:" .. name)
	if (new_scene == self.stack:peek() and options.reload) then
		self:reload(input, { close_modals = options.close_modals })
	else
		self.co = coroutine.create(function () ---@async
			if (options.close_modals) then
				self:_close_modals_f()
				local scene = self.stack:peek()
				if (scene._state == SCENE_ENUMS.STATES.PAUSED) then scene:resume() end
			end
			self:_replace_scene_f(new_scene, input)
		end)
		self:update(0)
	end
end

function M:back(options)
	assert(not self:is_working())
	self.co = coroutine.create(function () self:_back_scene_f(1, options) end) ---@async
	self:update(0)
end

--[[function M:back_to(name, options)
	CHECKS("?", "string", "?")
	assert(not self:is_working())
	self.co = coroutine.create(function () ---@async
		local scene = assert(self.scenes[name], "unknown scene:" .. name)
		local id = self.stack:find_scene(scene)
		assert(id, "no scene:" .. name .. " in stack")
		self:_back_scene_f(id, options)
	end)
end--]]

function M:close_modals()
	self.co = coroutine.create(function () ---@async
		self:_close_modals_f()
		local scene = self.stack:pop()
		self:_show_scene_f(scene, scene._input)
	end)
	self:update(0)
end

---@class SceneUnloadConfig
---@field new_scene Scene|nil wait scene loading if not nil
---@field skip_transition boolean|nil
---@field keep_show boolean|nil

---@param scene Scene
function M:_load_scene_f(scene) ---@async
	CHECKS("?", "class:Scene")
	if scene._state == SCENE_ENUMS.STATES.UNLOADED then scene:load() end
	local need_show_transition = false
	--wait next scene loaded
	while scene._state == SCENE_ENUMS.STATES.LOADING do coroutine.yield() end
	if scene._state == SCENE_ENUMS.STATES.HIDE then
		scene:show()
		need_show_transition = true
	end

	if scene._state == SCENE_ENUMS.STATES.PAUSED then scene:resume() end

	if (need_show_transition) then
		coroutine.yield()
		scene:transition(SCENE_ENUMS.TRANSITIONS.ON_SHOW)
	end
	scene:input_acquire()
end

---@param config SceneUnloadConfig|nil
---@param scene Scene
function M:_unload_scene_f(scene, config) ---@async
	CHECKS("?", "class:Scene", CHECKS_UNLOAD)
	config = config or {}

	if scene._state == SCENE_ENUMS.STATES.RUNNING then
		scene:input_release()
		if not config.keep_show and not config.skip_transition then scene:transition(SCENE_ENUMS.TRANSITIONS.ON_HIDE) end
		if not (config.keep_show and (scene._config.keep_running or scene._config.keep_running_scenes[config.new_scene._name]))
			and config.new_scene
		then
			scene:pause()
		end
	end

	--wait new scene to load.If not wait, user will see empty screen
	if (config.new_scene) then
		while config.new_scene._state == SCENE_ENUMS.STATES.LOADING do coroutine.yield() end
	end

	if scene._state == SCENE_ENUMS.STATES.PAUSED and not config.keep_show then scene:hide() end
	if scene._state == SCENE_ENUMS.STATES.HIDE and not scene._config.keep_loaded then scene:unload() end
end

---@async
function M:_close_modals_f()
	while (true) do
		local scene = self.stack:peek()
		if not scene or not scene._config.modal then break end
		LOG.i("unload modal scene:" .. scene._name, TAG)
		self:_unload_scene_f(self.stack:pop())
	end
	self.co = nil
end

---@param scene Scene
---@async
function M:_show_scene_f(scene, input)
	CHECKS("?", "class:Scene", "?")

	local current_scene = self.stack:peek()
	assert(not (current_scene == scene), "already show that scene:" .. scene._name)

	--start loading new scene.Before old was unloaded.
	scene._input = input
	if scene._state == SCENE_ENUMS.STATES.UNLOADED then scene:load(true) end

	---@type SceneUnloadConfig
	local unload_config = {}
	unload_config.new_scene = scene
	if (scene._config.modal) then
		assert(current_scene, "modal can't be first scene")
		local current_modal = current_scene._config.modal
		--show current scene when show new modal
		unload_config.keep_show = not current_modal
	else
		self:_close_modals_f()
	end
	if (current_scene) then self:_unload_scene_f(current_scene, unload_config) end
	self:_load_scene_f(scene)
	self.stack:push(scene)
	collectgarbage()
end

---@param scene Scene
---@async
function M:_replace_scene_f(scene, input)
	CHECKS("?", "class:Scene", "?")

	local current_scene = self.stack:peek()
	assert(current_scene, "can't replace. No current scene")
	assert(not (current_scene == scene), "already show that scene")

	--start loading new scene.Before old was unloaded.
	scene._input = input
	if scene._state == SCENE_ENUMS.STATES.UNLOADED then scene:load(true) end

	---@type SceneUnloadConfig
	local unload_config = {}
	unload_config.new_scene = scene

	assert(scene._config.modal == current_scene._config.modal, "modal can't replace scene and vice versa")
	self:_unload_scene_f(self.stack:pop(), unload_config)
	self:_load_scene_f(scene)
	self.stack:push(scene)
	collectgarbage()
end

---@async
function M:_back_scene_f(count, options)
	options = options or {}
	assert(count > 0)
	assert(#self.stack.stack > 1, "can't go back.")
	assert(#self.stack.stack - count >= 1, "not enough scenes")

	local result_scene = self.stack:peek(count)
	if result_scene then
		--start loading new scene.Before old was unloaded.
		if result_scene._state == SCENE_ENUMS.STATES.UNLOADED then result_scene:load(true) end
	end

	---@type SceneUnloadConfig
	local unload_config = {}
	unload_config.new_scene = result_scene

	for _ = 1, count do
		self:_unload_scene_f(self.stack:pop(), unload_config)
	end
	if result_scene then
		self:_load_scene_f(result_scene)
	end
	collectgarbage()
end

function M:get_scene_by_name(name) return assert(self.scenes[name], "unknown scene:" .. name) end

---@return Scene
function M:get_top() return self.stack:peek() end

return M
