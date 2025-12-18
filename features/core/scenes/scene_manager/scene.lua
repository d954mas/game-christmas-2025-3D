local CLASS = require "libs.class"
local CHECKS = require "libs.checks"
local HASHES = require "libs.hashes"
local LOG = require "libs.log"
local SCENE_ENUMS = require "features.core.scenes.scene_manager.scene_enums"
local SCENE_LOADER = require "features.core.scenes.scene_manager.scene_loader"
local ANALYTICS = require "features.sdk.analytics.analytics"

local TAG = "SCENE"

--scene does not have script instance.It worked in main instance(loader.script)
---@class Scene
---@field new fun():Scene
local Scene = CLASS.class('Scene')

---@param name string of scene.Must be unique
function Scene:initialize(name, url)
	CHECKS("?", "string", "string|url")
	self._name = name
	self._url = msg.url(url)
	self._input = nil
	self._config = {
		modal = false,
		keep_loaded = false,
		keep_running = false,
		---@type Scene[]
		keep_running_scenes = {}
	}
	self._state = SCENE_ENUMS.STATES.UNLOADED
end

function Scene:load(async)
	assert(self._state == SCENE_ENUMS.STATES.UNLOADED, "can't load scene in state:" .. self._state)
	self._state = SCENE_ENUMS.STATES.LOADING
	local time = chronos.nanotime()
	SCENE_LOADER.load(self, function ()
		self:on_load_done()
		self._state = SCENE_ENUMS.STATES.HIDE
		local load_time = chronos.nanotime() - time
		LOG.i(self._name .. " loaded", TAG)
		LOG.i(self._name .. " load time " .. load_time, TAG)
	end)
---@diagnostic disable-next-line: await-in-sync
	while (not async and self._state == SCENE_ENUMS.STATES.LOADING) do coroutine.yield() end
end

function Scene:on_load_done() end

function Scene:unload()
	assert(self._state == SCENE_ENUMS.STATES.HIDE)
	SCENE_LOADER.unload(self)
	self:on_unload_done()
	self._input = nil
	self._state = SCENE_ENUMS.STATES.UNLOADED
	LOG.i(self._name .. "unloaded", TAG)
end

function Scene:on_unload_done() end

function Scene:hide_before() end

function Scene:hide()
	assert(self._state == SCENE_ENUMS.STATES.PAUSED)
	ANALYTICS:scene_hide(self._name)
	msg.post(self._url, HASHES.DISABLE)
	self:on_hide_done()
	self._state = SCENE_ENUMS.STATES.HIDE
	LOG.i(self._name .. " hide", self._name)
end

function Scene:on_hide_done() end

function Scene:show()
	assert(self._state == SCENE_ENUMS.STATES.HIDE)
	ANALYTICS:scene_show(self._name)
	msg.post(self._url, HASHES.ENABLE)
	--	coroutine.yield() --wait before engine enable proxy
	self:on_show_done()
	self._state = SCENE_ENUMS.STATES.PAUSED
	LOG.i(self._name .. " show", TAG)
end

function Scene:on_show_done() end

function Scene:pause()
	assert(self._state == SCENE_ENUMS.STATES.RUNNING)
	msg.post(self._url, HASHES.SET_TIME_STEP, { factor = 0, mode = 0 })
	self:on_pause_done()
	self._state = SCENE_ENUMS.STATES.PAUSED
	LOG.i(self._name .. " paused", TAG)
end

function Scene:on_pause_done() end

function Scene:resume()
	assert(self._state == SCENE_ENUMS.STATES.PAUSED)
	msg.post(self._url, HASHES.SET_TIME_STEP, { factor = 1, mode = 0 })
	self:on_resume_done()
	self._state = SCENE_ENUMS.STATES.RUNNING
	LOG.i(self._name .. " resumed", TAG)
end

function Scene:on_resume_done() end

function Scene:input_acquire() self.handle_input = true end

function Scene:input_release() self.handle_input = false end

---@async
---@param transition string
---@diagnostic disable-next-line: unused-local
function Scene:transition(transition) end

--only top scene get input
---@diagnostic disable-next-line: unused-local
function Scene:on_input(action_id, action) end

---@diagnostic disable-next-line: unused-local
function Scene:update(dt) end

return Scene
