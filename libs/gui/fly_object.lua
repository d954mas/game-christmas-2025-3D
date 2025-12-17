local CLASS = require "libs.class"
local ACTIONS = require "libs.actions.actions"
local TWEEN = require "libs.tween"

local COLOR_INVISIBLE = vmath.vector4(1, 1, 1, 0)
local COLOR_WHITE = vmath.vector4(1, 1, 1, 1)

local GUI_SET_SCREEN_POSITION = gui.set_screen_position

--@class FlyObjectGui
local FlyObject = CLASS.class("FlyObject")

function FlyObject.new(nodes) return CLASS.new_instance(FlyObject, nodes) end

function FlyObject:initialize(nodes)
	self.vh = {
		root = nodes["root"],
		icon = nodes["icon"],
	}
	self.action = ACTIONS.Sequence.new(false)
	self.action.drop_empty = false
	self.alive = true
end

function FlyObject:reset()
	self.action:clear()
	gui.set_enabled(self.vh.root, false)
	self.alive = false
end

function FlyObject:destroy()
	if self.vh then
		gui.delete_node(self.vh.root)
		self.vh = nil
	end
end

function FlyObject:fly(config)
	local from = config.from
	--if (config.from_world) then
	--	from = CAMERAS.game_camera:world_to_screen(assert(config.from_world))
	--end
	GUI_SET_SCREEN_POSITION(self.vh.root, assert(from))
	gui.set_enabled(self.vh.root, true)

	local function_move = function ()
		from = config.from
		if (config.from_world) then
			--from = CAMERAS.game_camera:world_to_screen(assert(config.from_world))
		end
		local gui_pos_x, gui_pos_y = from.x, from.y

		local target = config.to
		local target_gui_x, target_gui_y = target.x, target.y

		local dx = target_gui_x - gui_pos_x
		local dy = target_gui_y - gui_pos_y

		local tween_table = { dx = 0, dy = 0 }
		local dx_time = math.abs(dx / (config.speed_x or 500))
		local dy_time = math.abs(dy / (config.speed_y or 500))
		local time = math.max(dx_time, dy_time)
		local tween_x = ACTIONS.TweenTable.new_noctx { delay = 0.1, object = tween_table, property = "dx", from = { dx = 0 },
			to = { dx = dx }, time = time, easing = TWEEN.easing.linear }
		local tween_y = ACTIONS.TweenTable.new_noctx { delay = 0.1, object = tween_table, property = "dy", from = { dy = 0 },
			to = { dy = dy }, time = time + 0.1, easing = TWEEN.easing.outQuad }
		local move_action = ACTIONS.Parallel.new(false)
		move_action:add_action(tween_x)
		move_action:add_action(tween_y)

		local set_position_action = ACTIONS.FunctionSteps.new(function (action, dt)
			if action.step == 0 then
				local v = vmath.vector3(0)
				while (tween_table.dx ~= dx and tween_table.dy ~= dy) do
					v.x, v.y = gui_pos_x + tween_table.dx, gui_pos_y + tween_table.dy
					GUI_SET_SCREEN_POSITION(self.vh.root, v)
					return false
				end
				action:next_step()
			elseif action.step == 1 then
				GUI_SET_SCREEN_POSITION(self.vh.root, config.to)
				while (not move_action:is_finished()) do
					move_action:update(dt)
					return false
				end
				action:next_step()
			end
			return true
		end, false)
		move_action:add_action(set_position_action)
		return move_action
	end

	local action_appear = ACTIONS.Parallel.new(false)
	if (config.appear) then
		gui.set_color(self.vh.root, COLOR_INVISIBLE)
		local tint = ACTIONS.TweenGui.new_noctx { object = self.vh.root, property = "color",
			from = COLOR_INVISIBLE, to = COLOR_WHITE, time = 0.15,
			easing = TWEEN.easing.inQuad }
		action_appear:add_action(tint)

		local sequenceAction = ACTIONS.Sequence.new(false)
		sequenceAction:add_action(ACTIONS.Wait.new(0.1))
		sequenceAction:add_action(function_move())
		action_appear:add_action(sequenceAction)
	else
		action_appear:add_action(function_move())
	end

	if (config.delay) then
		self.action:add_action(ACTIONS.Wait.new(config.delay))
	end
	self.action:add_action(action_appear)
	if config.disappear then
		self.action:add_action(ACTIONS.TweenGui.new_noctx { object = self.vh.root, property = "color",
			from = COLOR_WHITE, to = COLOR_INVISIBLE, time = 0.15,
			easing = TWEEN.easing.inQuad }
		)
	end
	self.action:add_action(function ()
		if (config.cb) then config.cb() end
	end)
	self.action:add_action(ACTIONS.Wait.new(config.delay))
	self.action:add_action(function ()
		self.alive = false
	end)
end

function FlyObject:update(dt)
	self.action:update(dt)
end

function FlyObject:is_animated()
	return not self.action:is_empty()
end

return FlyObject
