local ECS = require 'libs.ecs'
local CLASS = require 'libs.class'
local BALANCE = require "game.balance"

---@class UpdatePositionFromBody:EcsSystem
local System = CLASS.class("UpdatePositionFromBody", ECS.System)
function System.new() return CLASS.new_instance(System) end
System.filter = ECS.filter("position&body&!body_static")


function System:on_add(e)
	e.native_body = box2d.native_body_create(e.body,e.position)
end

function System:update()
	box2d.native_body_update(BALANCE.config.physics_scale)
end

function System:on_remove(e)
    if e.native_body then
        box2d.native_body_destroy(e.native_body)
    end
end
return System