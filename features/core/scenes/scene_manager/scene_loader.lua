local LOG = require "libs.log"
local CONTEXTS = require "libs.contexts_manager"
local TAG = "SceneLoader"
local HASHES = require "libs.hashes"
local M = {}

M.scene_load = {}   --current loading
M.scene_loaded = {} -- all loading proxy

---@param scene Scene
function M.load(scene, load_cb)
	assert(not M.scene_load[scene._url.fragment], "scene is loading now:" .. scene._name)
	assert(not M.scene_loaded[scene._url.fragment], "scene already loaded:" .. scene._name)
	msg.url()
	M.scene_load[scene._url.fragment] = load_cb
	LOG.i("start load:" .. scene._url, TAG)
	local ctx = CONTEXTS:set_context_top_loader()
	msg.post(scene._url, HASHES.ASYNC_LOAD)
	ctx:remove()
end

function M.load_done(url)
	local load_cb = M.scene_load[url.fragment]
	if load_cb then
		M.scene_load[url.fragment] = nil
		M.scene_loaded[url.fragment] = true
		load_cb()
	else
		LOG.w("scene:" .. url.fragment .. " not wait for loading", TAG)
	end
end

function M.unload(scene)
	msg.post(scene._url, HASHES.UNLOAD)
	M.scene_load[scene._url.fragment] = false
	M.scene_loaded[scene._url.fragment] = false
end

return M
