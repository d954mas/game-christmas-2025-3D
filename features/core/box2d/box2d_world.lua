local CLASS = require "libs.class"
local BOX2D_UTILS = require "features.core.box2d.utils"
local CHECKS = require "libs.checks"
local BALANCE = require "game.balance"

---@class Box2dWorldWrapper
local Box2dWorld = CLASS.class("Box2dWorldWrapper")

function Box2dWorld.new(config, game)
	return CLASS.new_instance(Box2dWorld, config, game)
end

---@param game GameWorld
function Box2dWorld:initialize(config, game)
	CHECKS("?", {
		gravity = "userdata",
		velocity_iterations = "number|nil",
		position_iterations = "number|nil",
		time_step = "number|nil",
	}, "?")

	self.groups = {
		GEOMETRY = bit.tobit(1),
		OBSTACLES = bit.tobit(2),
		PLAYER = bit.tobit(4),
	}

	self.masks = {
		EMPTY = bit.bor(0),
		GEOMETRY = bit.bor(self.groups.GEOMETRY, self.groups.OBSTACLES),
		OBSTACLES = bit.bor(self.groups.GEOMETRY, self.groups.OBSTACLES),
		PLAYER = bit.bor(0)
	}

	self.game = game
	self.config = config
	self.config.time_step = self.config.time_step or (1 / 60)
	self.config.velocity_iterations = self.config.velocity_iterations or 8
	self.config.position_iterations = self.config.position_iterations or 3
	self.world = box2d.NewWorld(self.config.gravity)
	---@type Box2dDebugDraw
	self.debug_draw = BOX2D_UTILS.create_debug_draw(BALANCE.config.physics_scale)
	self.debug_draw_flags = 0

	self.world:SetContactListener({
		-- BeginContact = function (contact) self:physics_begin_contact(contact) end,
		-- EndContact = function (contact) self:physics_end_contact(contact) end,
		-- PreSolve = function(contact, old_manifold) self:physics_pre_solve(contact, old_manifold) end,
		-- PostSolve = function(contact, impulse) self:physics_post_solve(contact, impulse) end
	})
end

function Box2dWorld:draw_debug_data_set_enabled(enable)
	self.debug_draw_flags = enable and bit.bor(box2d.b2Draw.e_shapeBit, box2d.b2Draw.e_jointBit, box2d.b2Draw.e_centerOfMassBit) or 0
	self.debug_draw:SetFlags(self.debug_draw_flags)
end

function Box2dWorld:update(dt)
	self.world:Step(self.config.time_step or dt, self.config.velocity_iterations, self.config.position_iterations)
end

function Box2dWorld:dispose()
	assert(self.world)
	self.world:Destroy()
	self.debug_draw:Destroy()
	self.world = nil
	self.debug_draw = nil
end

--[[
---@param contact Box2dContact
function Box2dWorld:physics_begin_contact(contact)
    local f1 = contact:GetFixtureA()
    local f2 = contact:GetFixtureB()
    local b1 = f1:GetBody()
    local b2 = f2:GetBody()
	
	---@type Entity|nil
    local f1_e = f1:GetUserData()
	---@type Entity|nil
    local f2_e = f2:GetUserData()
	---@type Entity|nil
    local b1_e = b1:GetUserData()
	---@type Entity|nil
    local b2_e = b2:GetUserData()
	
end--]]
--[[
---@param contact Box2dContact
	function Box2dWorld:physics_end_contact(contact)
   local f1 = contact:GetFixtureA()
    local f2 = contact:GetFixtureB()
    local b1 = f1:GetBody()
    local b2 = f2:GetBody()

 	---@type Entity|nil
    local f1_e = f1:GetUserData()
	---@type Entity|nil
    local f2_e = f2:GetUserData()
	---@type Entity|nil
    local b1_e = b1:GetUserData()
	---@type Entity|nil
    local b2_e = b2:GetUserData()
	
end--]]

return Box2dWorld
