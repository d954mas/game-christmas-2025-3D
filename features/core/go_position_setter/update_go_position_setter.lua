local CLASS = require "libs.class"
local ECS = require 'libs.ecs'


---@class PositionSetterSystem:EcsSystem
local System = CLASS.class("PositionSetterSystem", ECS.System)
System.filter = ECS.filter("position_setter_root")

function System.new() return CLASS.new_instance(System) end

function System:on_add_to_world()
	self.position_setter = go_position_setter.new()
end

function System:update()
	self.position_setter:update()
end

function System:on_add(e)
	self.position_setter:add(e.position_setter_root, e.position)
end

function System:on_remove(e)
	self.position_setter:remove(e.position_setter_root)
end

return System
