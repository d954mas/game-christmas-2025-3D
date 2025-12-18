local GAME = require "game.game_world"
local AutosizeLbl = require "libs.gui.autosize_label"

local StorageDebugEcs = require "features.core.ecs.ecs_debug_gui_storage_part"

local EcsDebugView = {}

local HASHES = {
	line = hash("ecs_debug/line"),
	line_lbl_name = hash("ecs_debug/line/lbl_name"),
	line_lbl_entities = hash("ecs_debug/line/lbl_entities"),
	line_lbl_t = hash("ecs_debug/line/lbl_t"),
	line_lbl_tavg = hash("ecs_debug/line/lbl_tavg"),
	line_lbl_tmax = hash("ecs_debug/line/lbl_tmax"),
}

function EcsDebugView:init()
	self.vh = {
		root = gui.get_node("ecs_debug/root"),
		line = gui.get_node("ecs_debug/line"),
	}
	self.lines = {}
	self.visible = false
	self.sorted_systems = {}
	self.sort_system_f = function (a, b)
		return a.__time.average_value > b.__time.average_value
	end
end

function EcsDebugView:update()
	if self.visible then
		local systems = GAME.ecs.ecs.systems
		for i = 1, math.max(#self.sorted_systems, #systems) do
			self.sorted_systems[i] = systems[i]
		end

		table.sort(self.sorted_systems, self.sort_system_f)
		for i = 1, #self.sorted_systems do
			local sys = self.sorted_systems[i]
			local line_nodes = self.lines[i]
			if not line_nodes then
				line_nodes = gui.clone_tree(self.vh.line)
				local vh = {
					root = line_nodes[HASHES.line],
					lbl_name = AutosizeLbl.new(line_nodes[HASHES.line_lbl_name]),
					lbl_entities = line_nodes[HASHES.line_lbl_entities],
					lbl_t = line_nodes[HASHES.line_lbl_t],
					lbl_tavg = line_nodes[HASHES.line_lbl_tavg],
					lbl_tmax = line_nodes[HASHES.line_lbl_tmax],
				}
				table.insert(self.lines, vh)
				local position = vmath.vector3(0, -i * 13, 0)
				gui.set_position(vh.root, position)
				vh.lbl_name:set_text(sys.__class.name)
				gui.set_text(vh.lbl_entities, #sys.entities_list)
				gui.set_text(vh.lbl_t, string.format("%.3f", sys.__time.current * 1000))
				gui.set_text(vh.lbl_tavg, string.format("%.3f", sys.__time.average_value * 1000))
				gui.set_text(vh.lbl_tmax, string.format("%.3f", sys.__time.max * 1000))
			end
		end
		for _ = #self.lines, #self.sorted_systems + 1, -1 do
			local line_nodes = table.remove(self.lines)
			gui.delete_node(line_nodes)
		end
	end
end

function EcsDebugView:set_visible(visible)
	self.visible = visible
	gui.set_enabled(self.vh.root, visible)
end

---@class EcsDebugFeature:Feature
local EcsDebugFeature = {}

---@param gui_script DebugGuiScript
function EcsDebugFeature:on_debug_gui_added(gui_script)
	EcsDebugView:init()
	EcsDebugView:set_visible(self.storage:is_show())
	table.insert(gui_script.views.panels.game.update_functions, function ()
		EcsDebugView:update()
	end)
	gui_script:add_game_checkbox("ECS", self.storage:is_show(), function (checkbox)
		self.storage:set_show(checkbox.checked)
		EcsDebugView:set_visible(checkbox.checked)
		print(checkbox.checked)
	end)
end

---@param storage Storage
function EcsDebugFeature:on_storage_init(storage)
	self.storage = StorageDebugEcs.new(storage)
end

return EcsDebugFeature
