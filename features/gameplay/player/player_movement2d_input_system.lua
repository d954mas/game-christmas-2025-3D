local ECS = require 'libs.ecs'
local HASHES = require "libs.hashes"
local INPUT = require "features.core.input.input"
local CLASS = require "libs.class"
local SM = require "features.core.scenes.scene_manager.scene_manager"
local SDK = require "features.sdk.ads.sdk"
local VirtualPadFeature = require "features.core.virtual_pad.virtual_pad_feature"


local HASHES_INPUT = HASHES.INPUT

---@class InputSystem:EcsSystem
local System = CLASS.class("InputSystem", ECS.System)
System.name = "InputSystem"

function System.new() return CLASS.new_instance(System) end

function System:initialize()
	ECS.System.initialize(self)
	self.move_left = 0
	self.move_right = 0
	self.move_up = 0
	self.move_down = 0
end

function System:draw(_)
	if INPUT.IGNORE or SM:get_top()._name ~= "GameScene" or SDK.show_ad or SM:is_working() then
		self.move_left = 0
		self.move_right = 0
		self.move_up = 0
		self.move_down = 0
	else
		self.move_up = (INPUT.get_key_data(HASHES_INPUT.ARROW_UP).pressed or INPUT.get_key_data(HASHES_INPUT.W).pressed) and 1 or 0
		self.move_down = (INPUT.get_key_data(HASHES_INPUT.ARROW_DOWN).pressed or INPUT.get_key_data(HASHES_INPUT.S).pressed) and 1 or 0
		self.move_left = (INPUT.get_key_data(HASHES_INPUT.ARROW_LEFT).pressed or INPUT.get_key_data(HASHES_INPUT.A).pressed) and 1 or 0
		self.move_right = (INPUT.get_key_data(HASHES_INPUT.ARROW_RIGHT).pressed or INPUT.get_key_data(HASHES_INPUT.D).pressed) and 1 or 0
	end
	---@class Entity
	local player = self.world.game_world.level_creator.player
	local movement = player.movement
	movement.input.x = self.move_right - self.move_left
	movement.input.y = self.move_up - self.move_down
	movement.max_speed_limit = 1

	local x,y, speed_limit = VirtualPadFeature:get_data()
	if x then
		movement.input.x, movement.input.y = x, y
		movement.max_speed_limit = speed_limit
	end
end

return System
