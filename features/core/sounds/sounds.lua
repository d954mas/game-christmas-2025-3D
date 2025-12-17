local EVENTS = require "libs.events"
local LOG = require "libs.log"
local LUME = require "libs.lume"
local CONTEXTS = require "libs.contexts_manager"

local HASH_MASTER = hash("master")
local HASH_SOUND = hash("sound")
local HASH_MUSIC = hash("music")

local EMPTY_CONFIG = {}

local TAG = "Sound"
local BASE_SOUND = 0.6
local BASE_SOUND_PART_2 = 1 - BASE_SOUND
---@class Sounds
local Sounds = {}

function Sounds:initialize()
	self.gate_time = 0.1
	self.gate_sounds = {}
	self.fade_in = {}
	self.fade_out = {}
	self.sounds = {
		---skip_play sound is in liveupdate it will be replaced and ready when liveupdate ready
		btn_click = { name = "btn_1", url = msg.url("main:/root#s_btn_click") },
		steps = {
			{ name = "step_1", url = msg.url("game_scene:/root#s_step_1") },
			{ name = "step_2", url = msg.url("game_scene:/root#s_step_2") },
			{ name = "step_3", url = msg.url("game_scene:/root#s_step_3"),
				resource = "/assets/sounds/step3.wavc", skip_play = true },
			{ name = "step_4", url = msg.url("game_scene:/root#s_step_4"),
				resource = "/assets/sounds/step3.wavc", skip_play = true },
			{ name = "step_5", url = msg.url("game_scene:/root#s_step_5"),
				resource = "/assets/sounds/step3.wavc", skip_play = true },
			{ name = "step_6", url = msg.url("game_scene:/root#s_step_6"),
				resource = "/assets/sounds/step3.wavc", skip_play = true },
		},
	}

	self.music = {
		main = { name = "main", url = msg.url("main:/root#sm_main"), fade_in = 3, fade_out = 3, skip_play = true },
	}

	EVENTS.WINDOW_EVENT:subscribe(false, function (_, window_event)
		if window_event == window.WINDOW_EVENT_FOCUS_LOST then
			self.focus = false
			sound.set_group_gain(HASH_MASTER, 0)
		elseif window_event == window.WINDOW_EVENT_FOCUS_GAINED then
			self.focus = true
			if (not self.paused) then
				sound.set_group_gain(HASH_MASTER, 1)
			end
		end
	end)

	self.paused = false
	self.focus = true
	self.master_gain = 1
	self.current_music = nil
	self.liveupdate_loaded = false
end

function Sounds:liveupdate_ready()
	--main sounds replace socket to liveupdate
	local sounds = {
		self.music.main,
	}
	local socket = hash("liveupdate")
	for _, s in ipairs(sounds) do
		s.url = msg.url(socket, s.url.path, s.url.fragment)
		s.skip_play = nil
	end
	self.liveupdate_loaded = true
	self:liveupdate_load_game_sound()
end

function Sounds:liveupdate_load_game_sound()
	if self.liveupdate_load_game_sound_done then return end
	if not self.liveupdate_loaded then return end
	if not CONTEXTS:exist(CONTEXTS.NAMES.GAME) then return end
	--game sound replace resource so it will be paused when scene is paused
	--use different files for every component. Resources with same name will have same content
	local game_sounds = {
		{ sound = self.sounds.steps[3],  resource = "/assets/sounds/step3.oggc" },
		{ sound = self.sounds.steps[4],  resource = "/assets/sounds/step4.oggc" },
		{ sound = self.sounds.steps[5],  resource = "/assets/sounds/step5.oggc" },
		{ sound = self.sounds.steps[6],  resource = "/assets/sounds/step6.oggc" },
	}
	for _, v in ipairs(game_sounds) do
		local s = assert(sys.load_resource(v.resource))
		resource.set_sound(assert(v.sound.resource, v.sound.url), s);
	end

	self.liveupdate_load_game_sound_done = true
end

local function to_gain(value)
	if value < 0.5 then
		return value * 2 * BASE_SOUND
	end
	return BASE_SOUND + (BASE_SOUND_PART_2 * (value - 0.5) * 2)
end

function Sounds:on_sound_volume_changed(volume)
	local sound_gain = to_gain(volume)
	sound.set_group_gain(HASH_SOUND, sound_gain)
end

function Sounds:on_music_volume_changed(volume)
	local music_gain = to_gain(volume)
	sound.set_group_gain(HASH_MUSIC, music_gain)
end

function Sounds:pause()
	LOG.i("pause", TAG)
	self.paused = true
	sound.set_group_gain(HASH_MASTER, 0)
end

function Sounds:resume()
	LOG.i("resume", TAG)
	self.paused = false
	if (self.focus) then
		sound.set_group_gain(HASH_MASTER, self.master_gain)
	end
end

function Sounds:update(dt)
	for k, v in pairs(self.gate_sounds) do
		self.gate_sounds[k] = v - dt
		if self.gate_sounds[k] < 0 then
			self.gate_sounds[k] = nil
		end
	end
	for k, v in pairs(self.fade_in) do
		local a = 1 - v.time / v.music.fade_in
		a = LUME.clamp(a, 0, 1)
		sound.set_gain(v.music.url, a)
		v.time = v.time - dt
		--        print("Fade in:" .. a)
		if (a == 1) then
			self.fade_in[k] = nil
		end
	end

	for k, v in pairs(self.fade_out) do
		local a = v.time / v.music.fade_in
		a = LUME.clamp(a, 0, 1)
		sound.set_gain(v.music.url, a)
		v.time = v.time - dt
		--      print("Fade out:" .. a)
		if (a == 0) then
			self.fade_out[k] = nil
			sound.stop(v.url)
		end
	end
end

function Sounds:play_sound(sound_obj, config)
	assert(sound_obj)
	assert(type(sound_obj) == "table")
	assert(sound_obj.url)
	config = config or EMPTY_CONFIG
	local result

	if not self.gate_sounds[sound_obj] or sound_obj.no_gate then
		self.gate_sounds[sound_obj] = sound_obj.gate_time or self.gate_time

		if sound_obj.skip_play then
			if config.on_complete then config.on_complete() end
		else
			result = sound.play(sound_obj.url, config.play_properties, config.on_complete)
		end
		LOG.i("play sound:" .. sound_obj.name, TAG)
	else
		LOG.i("gated sound:" .. sound_obj.name .. "time:" .. self.gate_sounds[sound_obj], TAG)
	end
	return result
end

function Sounds:play_music(music_obj)
	assert(music_obj)
	assert(type(music_obj) == "table")
	assert(music_obj.url)

	if (self.current_music) then
		if (self.current_music.fade_out) then
			self.fade_out[self.current_music] = { music = self.current_music, time = self.current_music.fade_out }
			self.fade_in[self.current_music] = nil
		else
			sound.stop(self.current_music.url)
		end
	end
	sound.stop(music_obj.url)
	sound.play(music_obj.url)

	if (music_obj.fade_in) then
		sound.set_gain(music_obj.url, 0)
		self.fade_in[music_obj] = { music = music_obj, time = music_obj.fade_in }
		self.fade_out[music_obj] = nil
	end
	self.current_music = music_obj

	LOG.i("play music:" .. music_obj.name, TAG)
end

function Sounds:play_step_sound()
	self:play_sound(self.sounds.steps[math.random(1, self.liveupdate_loaded and 6 or 2)])
end

function Sounds:play_btn_sound()
	self:play_sound(self.sounds.btn_click)
end

Sounds:initialize()
return Sounds
