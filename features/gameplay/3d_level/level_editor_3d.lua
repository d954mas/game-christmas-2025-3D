local CLASS = require "libs.class"
local ECS = require 'libs.ecs'
local LUME = require "libs.lume"
local INPUT = require "features.core.input.input"
local HASHES = require "libs.hashes"
local CAMERAS = require "features.core.camera.cameras_feature"
local IMGUI = require "features.debug.imgui.imgui_feature"

local DEF_OBJECTS = require "features.gameplay.3d_level.level_objects_def"

local RAYCAST_FROM = vmath.vector3()
local RAYCAST_TO = vmath.vector3()
local TEMP_V = vmath.vector3()
local TEMP_V4 = vmath.vector4()

local SCALE_1 = vmath.vector3(1, 1, 1)

local QUAT_Z0 = vmath.quat_rotation_z(0)

local TRANSFORM_MATRIX = vmath.matrix4()

local MATRIX_IDENTITY = vmath.matrix4()

local COLOR_BLOCKED = vmath.vector4(1, 0, 0, 1)
local COLOR_UNBLOCKED = vmath.vector4(0, 1, 0, 1)

local COLOR_RAY_TO_SELECTED = vmath.vector4(0, 0, 1, 1)

local TINT_SELECTED = vmath.vector4(0.3, 0.3, 1, 1)

--region Command
---@class EditorCommand:BaseClass
local Command = CLASS.class("Command")
---@param system EditorGuiSystem
function Command:initialize(system, value)
	self.system = assert(system)
	self.data = assert(system.world.game_world.level_creator.location_data.data)
	self.value = value
	self.value_saved = nil
	self.time = socket.gettime()
	self.final = false
	self.can_merge_time = 2
end

function Command:execute() end

function Command:undo() end

function Command:merge(_)
	self.time = socket.gettime()
end

function Command:can_merge(command)
	if self.final then return false end
	if self.__class ~= command.__class then return false end
	if command.time - self.time > self.can_merge_time then return false end
	return true
end

function Command:to_string()
	local value_string
	if types.is_vector3(self.value) then
		value_string = string.format("(%.2f, %.2f, %.2f)", self.value.x, self.value.y, self.value.z)
	elseif types.is_vector4(self.value) then
		value_string = string.format("(%.2f, %.2f, %.2f, %.2f)", self.value.x, self.value.y, self.value.z, self.value.w)
	else
		value_string = tostring(self.value)
	end

	local value_saved_string
	if types.is_vector3(self.value_saved) then
		value_saved_string = string.format("(%.2f, %.2f, %.2f)", self.value_saved.x, self.value_saved.y, self.value_saved.z)
	elseif types.is_vector4(self.value_saved) then
		value_saved_string = string.format("(%.2f, %.2f, %.2f, %.2f)", self.value_saved.x, self.value_saved.y, self.value_saved.z, self.value_saved.w)
	else
		value_saved_string = tostring(self.value_saved)
	end


	return "[" .. self.__class.name .. "]" .. value_string .. "(" .. value_saved_string .. ")"
end


local ChangeSpawnPointCommand = CLASS.class("ChangeSpawnPointCommand", Command)
function ChangeSpawnPointCommand.new(system, value)
	return CLASS.new_instance(ChangeSpawnPointCommand, system, value)
end

function ChangeSpawnPointCommand:initialize(...)
	Command.initialize(self, ...)
	self.can_merge_time = 5
end

function ChangeSpawnPointCommand:execute()
	self.value_saved = vmath.vector3(self.data.spawn_position)
	xmath.vector(self.data.spawn_position, self.value)
end

function ChangeSpawnPointCommand:undo()
	xmath.vector(self.data.spawn_position, self.value_saved)
end

function ChangeSpawnPointCommand:merge(command)
	Command.merge(self, command)
	xmath.vector(self.value, command.value)
end

---@class SelectObjectCommand:EditorCommand
local SelectObjectCommand = CLASS.class("SelectObjectCommand", Command)
function SelectObjectCommand.new(system, value)
	return CLASS.new_instance(SelectObjectCommand, system, value)
end

function SelectObjectCommand:initialize(system, value)
	Command.initialize(self, system, value or {})
	self.value = self.system:clone_selection(value)
end

function SelectObjectCommand:execute()
	self.value_saved = self.system:get_selection_snapshot()
	self.system:set_selected_objects(self.value)
end

function SelectObjectCommand:undo()
	self.system:set_selected_objects(self.value_saved or {})
end

function SelectObjectCommand:merge(command)
	Command.merge(self, command)
	self.value = self.system:clone_selection(command.value)
end

function SelectObjectCommand:can_merge(command)
	if Command.can_merge(self, command) then
		return self:selections_equal(self.value, command.value)
	end
end

function SelectObjectCommand:to_string()
	local function selection_to_string(selection)
		if not selection or #selection == 0 then
			return "[]"
		end
		local ids = {}
		for i = 1, #selection do
			ids[i] = selection[i] and selection[i].id or "nil"
		end
		return "[" .. table.concat(ids, ",") .. "]"
	end
	return "[" .. self.__class.name .. "]" .. selection_to_string(self.value) .. "(" .. selection_to_string(self.value_saved) .. ")"
end

function SelectObjectCommand:selections_equal(a, b)
	a = a or {}
	b = b or {}
	if #a ~= #b then return false end
	for i = 1, #a do
		if a[i] ~= b[i] then
			return false
		end
	end
	return true
end

---@class ObjectCommand:EditorCommand
local ObjectCommand = CLASS.class("ObjectCommand", Command)
function ObjectCommand.new(system, object, value)
	return CLASS.new_instance(ObjectCommand, system, object, value)
end

function ObjectCommand:initialize(system, object, value)
	Command.initialize(self, system, value)
	self.object = object
	self.can_merge_time = 5
end

function ObjectCommand:merge(command)
	Command.merge(self, command)
	self.value = command.value
end

function ObjectCommand:can_merge(command)
	if Command.can_merge(self, command) then
		return self.object == command.object
	end
end

function ObjectCommand:to_string()
	return "[" .. self.__class.name .. "]:" .. self.object.id .. " " .. tostring(self.value) .. "(" .. tostring(self.value_saved) .. ")"
end

local BuildObjectCommand = CLASS.class("BuildObjectCommand", ObjectCommand)
function BuildObjectCommand.new(system, object, value)
	return CLASS.new_instance(BuildObjectCommand, system, object, value)
end

function BuildObjectCommand:execute()
	local location_data = self.system.world.game_world.level_creator.location_data
	self.value_saved = location_data:is_build(self.object.id)
	location_data:editor_set_build(self.object.id, self.value)
end

function BuildObjectCommand:undo()
	local location_data = self.system.world.game_world.level_creator.location_data
	location_data:editor_set_build(self.object.id, self.value_saved)
end

---@class DeleteObjectCommand:ObjectCommand
local DeleteObjectCommand = CLASS.class("DeleteObjectCommand", ObjectCommand)
function DeleteObjectCommand.new(system, object)
	return CLASS.new_instance(DeleteObjectCommand, system, object)
end

function DeleteObjectCommand:execute()
	local location_data = self.system.world.game_world.level_creator.location_data
	location_data:editor_remove_object(self.object)
	local entity = self.system:find_entity_by_id(self.object.id)
	if entity then
		self.saved_entity = entity
		self.system.world:remove_entity(entity)
	end
	self.childrens = {}
	for i = 1, #self.system.objects_tree_map[self.object.id].childrens do
		local child = self.system.objects_tree_map[self.object.id].childrens[i]
		table.insert(self.childrens, child.object.id)
		child.object.parent = nil
		self.system:object_changed(child.object.id)
	end
	self.system:refresh_objects_list()
	self.system:trigger_need_update()
end

---@class DeleteRecursiveCommand:ObjectCommand
local DeleteRecursiveCommand = CLASS.class("DeleteRecursiveCommand", ObjectCommand)
function DeleteRecursiveCommand.new(system, object)
	return CLASS.new_instance(DeleteRecursiveCommand, system, object)
end

function DeleteRecursiveCommand:execute()
	self.removed_objects = {}
	self.saved_entities = {}
	local tree_node = self.system.objects_tree_map[self.object.id]
	if tree_node then
		self:remove_recursive(tree_node)
	else
		self:remove_object_and_entity(self.object)
		table.insert(self.removed_objects, self.object)
	end
	self.system:refresh_objects_list()
	self.system:trigger_need_update()
end

function DeleteRecursiveCommand:remove_recursive(tree_node)
	if not tree_node then return end
	self:remove_object_and_entity(tree_node.object)
	table.insert(self.removed_objects, tree_node.object)
	for i = 1, #tree_node.childrens do
		self:remove_recursive(tree_node.childrens[i])
	end
end

function DeleteRecursiveCommand:remove_object_and_entity(object)
	if not object then return end
	local location_data = self.system.world.game_world.level_creator.location_data
	location_data:editor_remove_object(object)
	local entity = self.system:find_entity_by_id(object.id)
	if entity then
		self.saved_entities[object.id] = entity
		self.system.world:remove_entity(entity)
	end
end

function DeleteRecursiveCommand:undo()
	local location_data = self.system.world.game_world.level_creator.location_data
	for i = 1, #self.removed_objects do
		local object = self.removed_objects[i]
		location_data:editor_add_object(object)
		local entity = self.saved_entities[object.id]
		if entity then
			self.system.world:add_entity(entity)
		end
	end
	self.system:refresh_objects_list()
	self.system:trigger_need_update()
end

function DeleteObjectCommand:undo()
	local location_data = self.system.world.game_world.level_creator.location_data
	location_data:editor_add_object(self.object)
	if self.saved_entity then
		self.system.world:add_entity(self.saved_entity)
	end
	for i = 1, #self.childrens do
		local child = self.childrens[i]
		local object = self.system.objects_tree_map[child].object
		object.parent = self.object.id
		self.system:object_changed(child)
	end
	self.system:refresh_objects_list()
	self.system:trigger_need_update()
end

---@class CloneObjectCommand:ObjectCommand
local CloneObjectCommand = CLASS.class("CloneObjectCommand", ObjectCommand)
function CloneObjectCommand.new(system, object)
	return CLASS.new_instance(CloneObjectCommand, system, object)
end

function CloneObjectCommand:initialize(system, object)
	ObjectCommand.initialize(self, system, object)
end

function CloneObjectCommand:clone_object(base_object)
	local object_cfg = LUME.clone_deep(base_object)
	object_cfg.id = self.system:new_id_for_clone_object(base_object.id)
	self.system.world.game_world.level_creator.location_data:editor_add_object(object_cfg)
	table.insert(self.value_saved, object_cfg)
	local tree_node = self.system.objects_tree_map[base_object.id]
	for i = 1, #tree_node.childrens do
		local child_object = self:clone_object(tree_node.childrens[i].object)
		child_object.parent = object_cfg.id
	end
	return object_cfg
end

function CloneObjectCommand:execute()
	self.value_saved = {}
	self:clone_object(self.object)
	local root = self.value_saved[1]
	root.position.z = root.position.z + 1

	local location_data = self.system.world.game_world.level_creator.location_data
	for i = 1, #self.value_saved do
		local object_cfg = self.value_saved[i]
		--	if object_cfg.type ~=DEF_OBJECTS.TYPES.COMMON.OBJECTS.EMPTY.id then
		local e = self.system.world.game_world.ecs.entities:create_object(object_cfg)
		self.system.world:add_entity(e)
		--end
	end

	location_data:build(root.id, true)
	self.system:select_object(root)
	self.system:refresh_objects_list()
	self.system:trigger_need_update()
end

function CloneObjectCommand:undo()
	local location_data = self.system.world.game_world.level_creator.location_data
	for i = #self.value_saved, 1, -1 do
		local object_cfg = self.value_saved[i]
		location_data:editor_remove_object(object_cfg)
		--if object_cfg.type ~=DEF_OBJECTS.TYPES.COMMON.OBJECTS.EMPTY.id then
		local entity = self.system:find_entity_by_id(object_cfg.id)
		if entity then
			self.system.world:remove_entity(entity)
		end
		--end
	end

	self.system:select_object(self.object)
	self.system:refresh_objects_list()
	self.system:trigger_need_update()
end

---@class NewObjectCommand:EditorCommand
local NewObjectCommand = CLASS.class("NewObjectCommand", Command)
function NewObjectCommand.new(system, object)
	return CLASS.new_instance(NewObjectCommand, system, object)
end

function NewObjectCommand:initialize(system, object)
	Command.initialize(self, system, object)
	self.object = object
end

function NewObjectCommand:execute()
	---@class LevelObjectData
	---@field is_build_cache bool|nil
	local object = {
		id = self.system:new_id_for_object(),
		type =DEF_OBJECTS.TYPES.COMMON.BASE.CUBE_1.id,
		scale = vmath.vector3(1, 1, 1),
		position = self.object and vmath.vector3(0) or vmath.vector3(self.system.world.game_world.level_creator.player.position) + vmath.vector3(0, 0, -1),
		rotation = vmath.quat_rotation_z(0),
		tint = vmath.vector4(1, 1, 1, 1),
		requirements = {},
		parent = self.object and self.object.id,
	}

	self.value_saved = object
	local location_data = self.system.world.game_world.level_creator.location_data
	location_data:editor_add_object(object)
	--if object.type ~=DEF_OBJECTS.TYPES.COMMON.OBJECTS.EMPTY.id then
	local e = self.system.world.game_world.ecs.entities:create_object(object)
	self.system.world:add_entity(e)
	--end
	self.system:refresh_objects_list()
	self.system:trigger_need_update()
end

function NewObjectCommand:can_merge(_)
	return false
end

function NewObjectCommand:undo()
	local location_data = self.system.world.game_world.level_creator.location_data
	location_data:editor_remove_object(self.value_saved)
	local entity = self.system:find_entity_by_id(self.value_saved.id)
	if entity then
		self.system.world:remove_entity(entity)
	end
	self.system:refresh_objects_list()
	self.system:trigger_need_update()
end

---@class ChangeIdCommand:ObjectCommand
local ChangeIdCommand = CLASS.class("ChangeIdCommand", ObjectCommand)
function ChangeIdCommand.new(system, object, new_id)
	return CLASS.new_instance(ChangeIdCommand, system, object, new_id)
end

function ChangeIdCommand:initialize(system, object, new_id)
	ObjectCommand.initialize(self, system, object)
	self.new_id = new_id
end

function ChangeIdCommand:execute()
	local location_data = self.system.world.game_world.level_creator.location_data
	location_data:editor_remove_object(self.object)
	self.value_saved = self.object.id
	--check id valid
	local object = self.system.objects_tree_map[self.new_id]
	if object then
		self.new_id = self.system:new_id_for_clone_object(self.new_id)
	end
	self.object.id = self.new_id
	self:replace_id(self.value_saved, self.new_id)

	location_data:editor_add_object(self.object)
	self.system:refresh_objects_list()
end

function ChangeIdCommand:undo()
	local location_data = self.system.world.game_world.level_creator.location_data
	location_data:editor_remove_object(self.object)
	local id = self.object.id
	self.object.id = self.value_saved
	self:replace_id(id, self.value_saved)
	location_data:editor_add_object(self.object)
	self.system:refresh_objects_list()
end

function ChangeIdCommand:replace_id(old, new)
	assert(old)
	assert(new)
	for _, object in ipairs(self.data.objects) do
		if object.parent == old then object.parent = new end
		for i = 1, 3 do
			if object.requirements[i] == old then object.requirements[i] = new end
		end
	end
end

---@class ChangeValueObjectCommand:ObjectCommand
local ChangeValueObjectCommand = CLASS.class("ChangeFloatValueObjectCommand", ObjectCommand)
function ChangeValueObjectCommand.new(system, object, property, value)
	return CLASS.new_instance(ChangeValueObjectCommand, system, object, property, value)
end

function ChangeValueObjectCommand:initialize(system, object, property, value)
	ObjectCommand.initialize(self, system, object)
	self.property = property
	self.value = value
end

function ChangeValueObjectCommand:can_merge(command)
	if ObjectCommand.can_merge(self, command) then
		return self.property == command.property
	end
end

function ChangeValueObjectCommand:execute()
	self.value_saved = self.object[self.property]
	if type(self.value_saved) == "userdata" then
		if types.is_vector3(self.value) then
			---@diagnostic disable-next-line: param-type-mismatch
			self.value_saved = vmath.vector3(self.value_saved)
		elseif types.is_vector4(self.value) then
			---@diagnostic disable-next-line: param-type-mismatch
			self.value_saved = vmath.vector4(self.value_saved)
		elseif types.is_quat(self.value) then
			---@diagnostic disable-next-line: param-type-mismatch
			self.value_saved = vmath.quat(self.value_saved)
		end
	end
	self.object[self.property] = self.value
	self.system:trigger_need_update()
	self.system:object_changed(self.object.id)
end

function ChangeValueObjectCommand:undo()
	local value = self.value_saved
	if type(value) == "userdata" then
		if types.is_vector3(value) then
			---@diagnostic disable-next-line: param-type-mismatch
			value = vmath.vector3(value)
		elseif types.is_vector4(value) then
			---@diagnostic disable-next-line: param-type-mismatch
			value = vmath.vector4(value)
		elseif types.is_quat(value) then
			---@diagnostic disable-next-line: param-type-mismatch
			value = vmath.quat(value)
		end
	end
	self.object[self.property] = value
	self.system:trigger_need_update()
	self.system:object_changed(self.object.id)
end

local function new_command(system, object, field, value)
    CLASS.new_instance(ChangePositionObjectCommand, system, object, field, value)
end

local ChangePositionObjectCommand = CLASS.class("ChangePositionObjectCommand", ChangeValueObjectCommand)
function ChangePositionObjectCommand.new(system, object, value)
	return CLASS.new_instance(ChangePositionObjectCommand, system, object, "position", value)
end

local ChangeRotationObjectCommand = CLASS.class("ChangeRotationObjectCommand", ChangeValueObjectCommand)
function ChangeRotationObjectCommand.new(system, object, value)
	return CLASS.new_instance(ChangeRotationObjectCommand, system, object, "rotation", value)
end

local ChangeScaleObjectCommand = CLASS.class("ChangeScaleObjectCommand", ChangeValueObjectCommand)
function ChangeScaleObjectCommand.new(system, object, value)
	return CLASS.new_instance(ChangeScaleObjectCommand, system, object, "scale", value)
end

local ChangeTypeObjectCommand = CLASS.class("ChangeTypeObjectCommand", ChangeValueObjectCommand)
function ChangeTypeObjectCommand.new(system, object, value)
	return CLASS.new_instance(ChangeTypeObjectCommand, system, object, "type", value)
end

local ChangeTintObjectCommand = CLASS.class("ChangeTintObjectCommand", ChangeValueObjectCommand)
function ChangeTintObjectCommand.new(system, object, value)
	return CLASS.new_instance(ChangeTintObjectCommand, system, object, "tint", value)
end

---@class TransformSelectionCommand:EditorCommand
local TransformSelectionCommand = CLASS.class("TransformSelectionCommand", Command)
function TransformSelectionCommand.new(system, payload)
	return CLASS.new_instance(TransformSelectionCommand, system, payload)
end

function TransformSelectionCommand:initialize(system, payload)
	Command.initialize(self, system, payload)
	self.operation = payload.operation
	self.transforms = payload.transforms or {}
	self.selection = self.system:clone_selection(payload.selection)
end

function TransformSelectionCommand:execute()
	self.saved = {}
	for i = 1, #self.selection do
		local object = self.selection[i]
		local transform = self.transforms[object.id]
		if transform then
			local record = { object = object }
			if transform.position then
				record.position = vmath.vector3(object.position)
				object.position = transform.position
			end
			if transform.rotation then
				record.rotation = vmath.quat(object.rotation)
				object.rotation = transform.rotation
			end
			if transform.scale then
				record.scale = vmath.vector3(object.scale)
				object.scale = transform.scale
			end
			table.insert(self.saved, record)
			self.system:object_changed(object.id)
		end
	end
	self.system:trigger_need_update()
end

function TransformSelectionCommand:undo()
	if not self.saved then return end
	for i = #self.saved, 1, -1 do
		local record = self.saved[i]
		if record.position then record.object.position = record.position end
		if record.rotation then record.object.rotation = record.rotation end
		if record.scale then record.object.scale = record.scale end
		self.system:object_changed(record.object.id)
	end
	self.system:trigger_need_update()
end

function TransformSelectionCommand:merge(command)
	if self:can_merge(command) then
		Command.merge(self, command)
		self.transforms = command.transforms
	end
end

function TransformSelectionCommand:can_merge(command)
	if not Command.can_merge(self, command) then return false end
	if self.operation ~= command.operation then return false end
	if #self.selection ~= #command.selection then return false end
	for i = 1, #self.selection do
		if self.selection[i] ~= command.selection[i] then
			return false
		end
	end
	return true
end

---@class ChangeParentObjectCommand:ChangeValueObjectCommand
local ChangeParentObjectCommand = CLASS.class("ChangeParentObjectCommand", ChangeValueObjectCommand)
function ChangeParentObjectCommand.new(system, object, value)
	return CLASS.new_instance(ChangeParentObjectCommand, system, object, "parent", value)
end

function ChangeParentObjectCommand:prepare_object(object)
	table.insert(self.saved_objects, {
		object = object,
		position = vmath.vector3(object.position),
		rotation = vmath.quat(object.rotation),
		scale = vmath.vector3(object.scale),
		world_transform = self.system.world.game_world.level_creator.location_data:get_world_transform(object.id),
	})
	local tree = self.system.objects_tree_map[object.id]
	for _, child in ipairs(tree.childrens) do
		self:prepare_object(child.object)
	end
end

function ChangeParentObjectCommand:fixed_tranform(data)
	local object = data.object
	local world_transform = data.world_transform
	local parent_inverse_transform
	if object.parent then
		local parent_transform = self.system.world.game_world.level_creator.location_data:get_world_transform(object.parent, true)
		parent_inverse_transform = vmath.inv(parent_transform)
	else
		parent_inverse_transform = vmath.matrix4()
	end
	local local_transform = parent_inverse_transform * world_transform

	xmath.matrix_get_transforms(local_transform, object.position, object.scale, object.rotation)
end

function ChangeParentObjectCommand:execute()
	self.saved_objects = {}
	self:prepare_object(self.object)
	ChangeValueObjectCommand.execute(self)
	--for _, data in ipairs(self.saved_objects) do
	self:fixed_tranform(self.saved_objects[1])
	--end

	self.system:refresh_objects_list()
	for _, data in ipairs(self.saved_objects) do
		self.system:object_changed(data.object.id)
	end
end

function ChangeParentObjectCommand:undo()
	for _, data in ipairs(self.saved_objects) do
		data.object.position = vmath.vector3(data.position)
		data.object.rotation = vmath.quat(data.rotation)
		data.object.scale = vmath.vector3(data.scale)
	end

	ChangeValueObjectCommand.undo(self)
	self.system:refresh_objects_list()
	for _, data in ipairs(self.saved_objects) do
		self.system:object_changed(data.object.id)
	end
end

---@class ChangeRequirmentsObjectCommand:ObjectCommand
local ChangeRequirmentsObjectCommand = CLASS.class("ChangeRequirmentsObjectCommand", ObjectCommand)
function ChangeRequirmentsObjectCommand.new(system, object, idx, value)
	return CLASS.new_instance(ChangeRequirmentsObjectCommand, system, object, idx, value)
end

function ChangeRequirmentsObjectCommand:initialize(system, object, idx, value)
	ObjectCommand.initialize(self, system, object, value)
	print("ChangeRequirmentsObjectCommand:initialize", idx, value)
	self.requirment_idx = idx
end

function ChangeRequirmentsObjectCommand:execute()
	self.value_saved = self.object.requirements[self.requirment_idx]
	self.object.requirements[self.requirment_idx] = self.value
	self.system:object_changed(self.object.id)
end

function ChangeRequirmentsObjectCommand:undo()
	self.object.requirements[self.requirment_idx] = self.value_saved
	self.system:object_changed(self.object.id)
end

function ChangeRequirmentsObjectCommand:can_merge(command)
	if ObjectCommand.can_merge(self, command) then
		return self.requirment_idx == command.requirment_idx
	end
end
--endregion



---@class EditorGuiSystem:EcsSystem
local System = CLASS.class("RaycastChooseObjectSystem", ECS.System)

function System.new() return CLASS.new_instance(System) end

function System:initialize()
	ECS.System.initialize(self)
	self.history = {}
	self.unsaved = false

	self.raycast_groups = {
		hash("geometry"),
		hash("obstacle"),
		hash("geometry_block_view"),
		hash("editor")
	}
	self.raycast_mask = physics_utils.physics_count_mask(self.raycast_groups)
	self.selected_objects = {}
	self.selected_objects_map = {}
	self.button_show = false
	self.highlighted_entities = {}

	self.gizmo = {
		mode = imgui_gizmo and imgui_gizmo.MODE_WORLD,
		operation = imgui and imgui_gizmo.OPERATION_TRANSLATE,
		matrix = vmath.matrix4(),
		id = nil
	}
end

local function sort_tree(tree_node)
	table.sort(tree_node.childrens, function (a, b)
		return a.object.id < b.object.id
	end)
	for _, child in ipairs(tree_node.childrens) do
		sort_tree(child)
	end
end

function System:refresh_objects_list()
	self.objects_list = {}
	self.objects_tree = {
		object = nil,
		parent = nil,
		childrens = {}
	}
	self.objects_tree_map = {}
	for _, object in ipairs(self.world.game_world.level_creator.location_data.data.objects) do
		table.insert(self.objects_list, object)
		self.objects_tree_map[object.id] = {
			object = object,
			parent = nil,
			childrens = {}
		}
	end

	for _, tree_node in pairs(self.objects_tree_map) do
		local object = tree_node.object
		if not object.parent then
			table.insert(self.objects_tree.childrens, tree_node)
		else
			tree_node.parent = self.objects_tree_map[object.parent]
			table.insert(tree_node.parent.childrens, tree_node)
		end
	end

	sort_tree(self.objects_tree)
	table.sort(self.objects_list, function (a, b)
		return a.id < b.id
	end)
	self:cleanup_selected_objects()
end

function System:on_add_to_world()
	self.history = {}
	self:refresh_objects_list()
end

function System:execute_command(command)
	table.insert(self.history, command)
	command:execute()
	self.unsaved = true
	local prev_command = self.history[#self.history - 1]
	if prev_command then
		if prev_command:can_merge(command) then
			prev_command:merge(command)
			self.history[#self.history] = nil
		end
	end
end

function System:undo()
	print("undo:" .. #self.history)
	local command = table.remove(self.history)
	if command then
		command:undo()
		self.unsaved = true
	end
end

function System:find_entity_by_id(id)
	for _, e in ipairs(self.world.entities_list) do
		if e.object_config and e.object_config.id == id then
			return e
		end
	end
end

function System:draw_object_tree(tree_node)
	local object = tree_node.object
	local selected = self:is_object_selected(object)

	if selected then
		imgui.push_style_color(imgui.ImGuiCol_Text, 0.2, 1.0, 0.2, 1.0)
	end
	local flags = #tree_node.childrens == 0 and imgui.TREENODE_LEAF or 0
	if selected then
		flags = bit.bor(flags, imgui.TREENODE_SELECTED)
	end
	local node_id = tree_node.object.id .. "(" .. tree_node.object.type .. ")##" .. tree_node.object.id
	local node_open = imgui.tree_node(node_id, flags)
	if selected then
		imgui.pop_style_color(1) -- pop the four colors pushed earlier
	end
	flags = imgui.DROPFLAGS_NONE
	if (imgui.begin_dragdrop_source(flags)) then
		imgui.set_dragdrop_payload("DND_OBJECT", object.id);
		imgui.text(object.id)
		imgui.end_dragdrop_source();
	end

	if (imgui.begin_dragdrop_target(flags)) then
		local payload = imgui.accept_dragdrop_payload("DND_OBJECT")
		if payload then
			local children = self.world.game_world.level_creator.location_data:find_by_id(payload)
			self:execute_command(ChangeParentObjectCommand.new(self, children, object.id))
		end
		imgui.end_dragdrop_target();
	end

	if (imgui.begin_popup_context_item()) then
		if (imgui.menu_item("New")) then
			self:execute_command(NewObjectCommand.new(self, object))
		end
		if (imgui.menu_item("Clone")) then
			self:execute_command(CloneObjectCommand.new(self, object))
		end
		if (imgui.menu_item("Delete")) then
			self:execute_command(DeleteObjectCommand.new(self, object))
		end
		if (imgui.menu_item("Delete Recursive")) then
			self:execute_command(DeleteRecursiveCommand.new(self, object))
		end
		imgui.end_popup()
	end

	if node_open then
		if imgui.is_item_clicked(imgui.MOUSEBUTTON_LEFT) then
			local additive = self:is_multi_select_modifier_active()
			local selection = self:build_selection_result(object, additive)
			if not self:is_same_selection(selection) then
				self:execute_command(SelectObjectCommand.new(self, selection))
			end
		end
	end

	imgui.same_line()
	local location_data = self.world.game_world.level_creator.location_data
	local changed, x = imgui.checkbox("Build##object_build" .. object.id, location_data:is_build(object.id))
	if changed then
		self:execute_command(BuildObjectCommand.new(self, object, x))
	end

	if node_open then
		for _, child in ipairs(tree_node.childrens) do
			self:draw_object_tree(child)
		end
		imgui.tree_pop()
	end
	imgui.push_id(node_id)

	imgui.pop_id()
end

function System:draw_location_ui()
	local location_data = self.world.game_world.level_creator.location_data
	local data = location_data.data
	local window_title = "LOCATION:" .. location_data.def.path:sub(26)

	local changed, value, x, y, z = false, false, 0, 0, 0
	local i1, i2, i3, i4 = 0, 0, 0, 0

	--if self.unsaved then
	--window_title = window_title .. "(unsaved)"
	--end

	window_title = window_title .. "##window_title"

	imgui.begin_window(window_title, false, imgui.WINDOWFLAGS_MENUBAR)

	--region Menubar
	if imgui.begin_menu_bar() then
		if imgui.begin_menu("File") then
			if imgui.menu_item("Save") then
				self.unsaved = false
				local folder = LUME.get_current_folder()
				if folder then
					folder = folder .. location_data.def.path
					local file = io.open(folder, "w+")
					if file then
						---@class SavedLevelData
						---@diagnostic disable-next-line: assign-type-mismatch
						local saved_data = LUME.clone_deep(location_data.data)
						saved_data.spawn_position = { saved_data.spawn_position.x, saved_data.spawn_position.y, saved_data.spawn_position.z }
						---@diagnostic disable-next-line: undefined-field
						for _, object in ipairs(saved_data.objects) do
							for k, v in pairs(object) do
								local result_value = v
								local is_default_value = false
								if type(v) == "userdata" then
									if types.is_vector3(v) then
										---@diagnostic disable-next-line: undefined-field
										result_value = { v.x, v.y, v.z }
										is_default_value = result_value[1] == 0 and result_value[2] == 0 and result_value[3] == 0
									elseif types.is_vector4(v) then
										---@diagnostic disable-next-line: undefined-field
										result_value = { v.x, v.y, v.z, v.w }
										is_default_value = result_value[1] == 0 and result_value[2] == 0 and result_value[3] == 0 and result_value[4] == 0
									elseif types.is_quat(v) then
										---@diagnostic disable-next-line: undefined-field
										result_value = { v.x, v.y, v.z, v.w }
										is_default_value = result_value[1] == 0 and result_value[2] == 0 and result_value[3] == 0 and result_value[4] == 1
									else
										error("unknown type:" .. k .. "->" .. tostring(v))
									end
								end

								if k == "tint" then
									is_default_value = result_value[1] == 1 and result_value[2] == 1 and result_value[3] == 1 and result_value[4] == 1
								elseif k == "scale" then
									is_default_value = result_value[1] == 1 and result_value[2] == 1 and result_value[3] == 1
								elseif k == "income" then
									is_default_value = true
								elseif k == "need_button" then
									is_default_value = result_value == false
								elseif k == "is_island" then
									is_default_value = result_value == false
								elseif k == "requirements" then
									is_default_value = #result_value == 0
								elseif k == "cost" then
									is_default_value = true
								elseif k == "group" then
									is_default_value = true
								elseif k == "location_percent" then
									is_default_value = result_value == 0
								elseif k == "is_build_cache" then
									is_default_value = true
								elseif k == "difficulty" then
									is_default_value = false
							elseif k == "spawner_config" then
								is_default_value = false
							end
								if is_default_value then
									object[k] = nil
								else
									object[k] = result_value
								end

								--remove default values
							end
						end
						file:write(json.encode(saved_data))
						file:close()
					end
				end
			end

			if imgui.menu_item("Load") then
				local folder = LUME.get_current_folder()
				if folder then
					local result, path = diags.open("json", folder .. "\\assets\\custom\\locations")
					if result == 1 and path then
						local file, err = io.open(path, "r")
						if file and not err then
							file:close()
							local _, end_pos = path:find("assets\\custom\\locations")
							local location_path = path:sub(end_pos - 23)
							location_path = location_path:gsub("\\", "/")
							local def = DEFS.LOCATIONS.BY_ID.EDITOR
							def.path = location_path
							timer.delay(0, false, function ()
								self.world.game_world:change_location(DEFS.LOCATIONS.BY_ID.EDITOR.id)
							end)
						end
					end
				end
			end

			imgui.end_menu()
		end

		imgui.end_menu_bar()
	end
	--endregion

	if (imgui.tree_node("location" .. "##location_root")) then
		changed, value = imgui.input_int("Income##LocationIncome", data.income)
		if changed then
			self:execute_command(ChangeIncomeCommand.new(self, value))
		end
		changed, x, y, z = imgui.input_float3("Spawn Position##LocationSpawnPosition", data.spawn_position.x, data.spawn_position.y, data.spawn_position.z)
		if changed then
			self:execute_command(ChangeSpawnPointCommand.new(self, vmath.vector3(x, y, z)))
		end

		if imgui.button("RESPAWN", 80, 20) then
			self.world.game_world:teleport(self.world.game_world.level_creator.player, data.spawn_position)
		end

		local water = data.water
		changed, value = imgui.checkbox("Water#level_water", water.show)

		if changed then
			self:execute_command(ToggleWaterCommand.new(self, value))
		end

		changed, x, y, z = imgui.input_float3("pos(cx,y,cz)##level_water_pos", water.cx, water.y, water.cz)
		if changed then
			local water_new = LUME.clone_deep(water)
			water_new.cx = x
			water_new.y = y
			water_new.cz = z
			self:execute_command(ChangeWaterCommand.new(self, water_new))
		end

		changed, i1, i2, i3, i4 = imgui.input_int4("w,h,col,row##level_water_water", water.w, water.h, water.columns, water.rows)
		if changed then
			local water_new = LUME.clone_deep(water)
			water_new.w = i1
			water_new.h = i2
			water_new.columns = i3
			water_new.rows = i4
			self:execute_command(ChangeWaterCommand.new(self, water_new))
		end

		local cells = data.cells
		if cells then
			imgui.separator()
			imgui.text("Cells")

			changed, value = imgui.input_float("Cell Size##level_cells_size", cells.cell_size or 0)
			if changed then
				local cells_new = LUME.clone_deep(cells)
				cells_new.cell_size = value
				self:execute_command(ChangeCellsCommand.new(self, cells_new))
			end

			changed, i1, i2 = imgui.input_int2("World Size (W/H)##level_cells_world", cells.world_width or 0, cells.world_height or 0)
			if changed then
				local cells_new = LUME.clone_deep(cells)
				cells_new.world_width = i1
				cells_new.world_height = i2
				self:execute_command(ChangeCellsCommand.new(self, cells_new))
			end

			changed, i1, i2 = imgui.input_int2("Ground Cell/Chunk##level_cells_ground", cells.ground_cell_size or 0, cells.ground_chunk_size or 0)
			if changed then
				local cells_new = LUME.clone_deep(cells)
				cells_new.ground_cell_size = i1
				cells_new.ground_chunk_size = i2
				self:execute_command(ChangeCellsCommand.new(self, cells_new))
			end
		end

		imgui.tree_pop()
	end

	if (imgui.tree_node("scene" .. "##location_scene")) then
		if (imgui.begin_popup_context_item()) then
			if (imgui.menu_item("New")) then
				self:execute_command(NewObjectCommand.new(self, nil))
			end
			imgui.end_popup()
		end
		for _, object in ipairs(self.objects_tree.childrens) do
			self:draw_object_tree(object)
		end
		imgui.tree_pop()
	end

	imgui.end_window()
end

function System:draw_terrain_ui()
	if not self.world or not self.world.game_world or not self.world.game_world.level_creator then return end
	if not imgui.begin_window("Terrain##TerrainEditor", false) then
		imgui.end_window()
		return
	end
	local edit = self.terrain_edit
	if not edit then
		imgui.text("Terrain editing unavailable")
		imgui.end_window()
		return
	end
	if edit.options_dirty then
		self:refresh_terrain_value_options()
	end
	local mode = edit.mode or TERRAIN_EDIT_MODE.OFF
	local preview = TERRAIN_MODE_NAMES[mode] or TERRAIN_MODE_NAMES[TERRAIN_EDIT_MODE.OFF]
	if imgui.begin_combo("Mode##TerrainEditMode", preview) then
		for _, mode_id in ipairs(TERRAIN_MODE_ORDER) do
			local selected = mode == mode_id
			if imgui.selectable(TERRAIN_MODE_NAMES[mode_id], selected) then
				mode = mode_id
			end
			if selected then imgui.set_item_default_focus() end
		end
		imgui.end_combo()
	end
	if mode ~= edit.mode then
		edit.mode = mode
		if mode == TERRAIN_EDIT_MODE.OFF then
			self:update_terrain_selection(nil)
		end
	end

	local location_data = self:get_location_data()
	if not location_data or not location_data.data or not location_data.data.terrain then
		imgui.text("No terrain data in this location.")
		imgui.end_window()
		return
	end

	local grid = location_data:get_terrain_grid_info()
	if grid then
		imgui.text(string.format("Grid: %dx%d (cell %.2f)", grid.columns, grid.rows, grid.cell_size))
	end
	local show_all_cells = location_data:get_show_all_terrain_cells()
	local changed, show_all_value = imgui.checkbox("Show locked terrain##TerrainShowAll", show_all_cells)
	local value = nil
	if changed then
		location_data:set_show_all_terrain_cells(show_all_value)
	end
	imgui.separator()

	if edit.mode == TERRAIN_EDIT_MODE.OFF then
		imgui.text("Mode disabled. Use normal object editing.")
	elseif edit.mode == TERRAIN_EDIT_MODE.SELECT then
		if edit.selected_index then
			imgui.text(string.format("Selected #%d (col %d, row %d)", edit.selected_index, (edit.selected_column or 0) + 1,
				(edit.selected_row or 0) + 1))
			changed, value = self:terrain_value_selector("Type", "SelectType", edit.inspect_type or 0,
				edit.type_options, edit.type_name_by_value)
			if changed then
				self:update_selected_terrain_type(value)
			end
			changed, value = self:terrain_value_selector("Shape", "SelectShape", edit.inspect_shape or 0,
				edit.shape_options, edit.shape_name_by_value)
			if changed then
				self:update_selected_terrain_shape(value)
			end
			imgui.separator()
			local current_color = edit.inspect_color or vmath.vector4(1, 1, 1, 1)
			local color_slider_changed, sr, sg, sb, sa = imgui.slider_float4("Color##TerrainCellColorSlider", current_color.x, current_color.y, current_color.z,
				current_color.w, 0, 1)
			if color_slider_changed then
				current_color = vmath.vector4(sr, sg, sb, sa)
				self:update_selected_terrain_color(current_color)
			end
			local color_changed, r, g, b, a = imgui.input_float4("Color##TerrainCellColor", current_color.x, current_color.y, current_color.z, current_color.w)
			if color_changed then
				self:update_selected_terrain_color(vmath.vector4(r, g, b, a))
			end
			imgui.same_line()
			if imgui.button("Reset##TerrainColorReset") then
				self:update_selected_terrain_color(vmath.vector4(1, 1, 1, 1))
			end
			local current_offset = edit.inspect_offset or vmath.vector3(0, 0, 0)
			local offset_slider_changed, ox, oy, oz = imgui.slider_float3("Offset##TerrainCellOffsetSlider", current_offset.x, current_offset.y, current_offset
				.z, TERRAIN_OFFSET_SLIDER_MIN, TERRAIN_OFFSET_SLIDER_MAX)
			if offset_slider_changed then
				current_offset = vmath.vector3(ox, oy, oz)
				self:update_selected_terrain_offset(current_offset)
			end
			local offset_changed, iox, ioy, ioz = imgui.input_float3("Offset##TerrainCellOffset", current_offset.x, current_offset.y, current_offset.z)
			if offset_changed then
				self:update_selected_terrain_offset(vmath.vector3(iox, ioy, ioz))
			end
			imgui.same_line()
			if imgui.button("Reset##TerrainOffsetReset") then
				self:update_selected_terrain_offset(vmath.vector3(0, 0, 0))
			end
			local current_scale = edit.inspect_scale or vmath.vector3(1, 1, 1)
			local avg_scale = (current_scale.x + current_scale.y + current_scale.z) / 3
			local uniform_changed, uniform_value = imgui.slider_float("Scale All##TerrainScaleUniform", avg_scale, TERRAIN_SCALE_SLIDER_MIN,
				TERRAIN_SCALE_SLIDER_MAX)
			if uniform_changed then
				local uniform_vec = vmath.vector3(uniform_value, uniform_value, uniform_value)
				self:update_selected_terrain_scale(uniform_vec)
				current_scale = uniform_vec
			end
			local scale_slider_changed, sx, sy, sz = imgui.slider_float3("Scale##TerrainCellScaleSlider", current_scale.x, current_scale.y, current_scale.z,
				TERRAIN_SCALE_SLIDER_MIN, TERRAIN_SCALE_SLIDER_MAX)
			if scale_slider_changed then
				current_scale = vmath.vector3(sx, sy, sz)
				self:update_selected_terrain_scale(current_scale)
			end
			local scale_changed, isx, isy, isz = imgui.input_float3("Scale##TerrainCellScale", current_scale.x, current_scale.y, current_scale.z)
			if scale_changed then
				self:update_selected_terrain_scale(vmath.vector3(isx, isy, isz))
			end
			imgui.same_line()
			if imgui.button("Reset##TerrainScaleReset") then
				self:update_selected_terrain_scale(vmath.vector3(1, 1, 1))
			end
		else
			imgui.text("Tap a cell to inspect and edit it.")
		end
	elseif edit.mode == TERRAIN_EDIT_MODE.PAINT then
		imgui.text("Tap to paint cells with the selected brush.")
		changed, value = self:terrain_value_selector("Brush Type", "BrushType", edit.brush_type or 0,
			edit.type_options, edit.type_name_by_value)
		if changed then
			edit.brush_type = value
			edit.options_dirty = true
		end
		changed, value = self:terrain_value_selector("Brush Shape", "BrushShape", edit.brush_shape or 0,
			edit.shape_options, edit.shape_name_by_value)
		if changed then
			edit.brush_shape = value
			edit.options_dirty = true
		end
		if edit.selected_index then
			imgui.separator()
			imgui.text(string.format("Last cell #%d (col %d, row %d)", edit.selected_index, (edit.selected_column or 0) + 1,
				(edit.selected_row or 0) + 1))
		end
	end

	imgui.end_window()
end

function System:draw_history_ui()
	local window_title = "HISTORY"

	imgui.begin_window(window_title, false)
	for i = #self.history, 1, -1 do
		local command = self.history[i]
		imgui.text(command:to_string())
	end

	imgui.end_window()
end

function System:update_selected_object_button()
	local selected_object = self:get_primary_selected_object()
	local need_show = self.button_show and selected_object
	if need_show and not self.show_selected_object_button_model then
		local urls = collectionfactory.create("/root#factory_common_button_green", vmath.vector3(0, 0, 0))
		self.show_selected_object_button_model = {
			root = urls[hash("/root")],
		}
	end
	if not need_show and self.show_selected_object_button_model then
		go.delete(self.show_selected_object_button_model.root, true)
		self.show_selected_object_button_model = nil
	end
	if self.show_selected_object_button_model then
		local location_data = self.world.game_world.level_creator.location_data
		local world_matrix = location_data:get_world_transform(selected_object.id)
		xmath.vector3_set_components(TEMP_V, 1 / selected_object.scale.x, 1 / selected_object.scale.y, 1 / selected_object.scale.z)
		xmath.mul_per_elem(TEMP_V, selected_object.button_position, TEMP_V)
		--remove scale from matrix
		xmath.matrix_from_transforms(TRANSFORM_MATRIX, TEMP_V, SCALE_1, QUAT_Z0)
		xmath.matrix_mul(TRANSFORM_MATRIX, world_matrix, TRANSFORM_MATRIX)

		local position = vmath.vector3()
		local rotation = vmath.quat()
		local scale = vmath.vector3()
		xmath.matrix_get_transforms(TRANSFORM_MATRIX, position, scale, rotation)



		go.set_position(position, self.show_selected_object_button_model.root)
		go.set_rotation(rotation, self.show_selected_object_button_model.root)
	end
end

function System:trigger_need_update()
	self.world.game_world.level_creator.location_data:trigger_location_changed()
end

function System:get_location_data()
	return self.world and self.world.game_world and self.world.game_world.level_creator and self.world.game_world.level_creator.location_data
end

local function read_numeric_entry(entry, index)
	if type(entry) ~= "table" then return nil end
	local value = entry[index]
	if value == nil then value = entry[tostring(index)] end
	return value
end

local function decode_entry_color(entry)
	if type(entry) ~= "table" then
		return vmath.vector4(1, 1, 1, 1)
	end
	local color = read_numeric_entry(entry, 3) or entry.color or entry["color"]
	if type(color) == "table" then
		return vmath.vector4(color[1] or color.r or color.x or 1,
			color[2] or color.g or color.y or 1,
			color[3] or color.b or color.z or 1,
			color[4] or color.a or color.w or 1)
	end
	return vmath.vector4(1, 1, 1, 1)
end

local function resolve_offset_component(value, key, index)
	if not value then return nil end
	local component = nil
	local value_type = type(value)
	if value_type == "table" then
		component = value[key]
		if component == nil and index then component = value[index] end
	elseif value_type == "userdata" then
		component = value[key]
	end
	return component
end

local function decode_entry_offset(entry)
	if type(entry) ~= "table" then
		return vmath.vector3(0, 0, 0)
	end
	local source = entry.offset or entry["offset"] or entry[4]
	if type(source) ~= "table" then
		return vmath.vector3(0, 0, 0)
	end
	local x = tonumber(resolve_offset_component(source, "x", 1)) or 0
	local y = tonumber(resolve_offset_component(source, "y", 2)) or 0
	local z = tonumber(resolve_offset_component(source, "z", 3)) or 0
	return vmath.vector3(x, y, z)
end

local function resolve_scale_component(value, key, index)
	if not value then return nil end
	local value_type = type(value)
	local component = nil
	if value_type == "table" then
		component = value[key]
		if component == nil and index then component = value[index] end
	elseif value_type == "userdata" then
		component = value[key]
	end
	if component == nil then return nil end
	return tonumber(component)
end

local function decode_entry_scale(entry)
	if type(entry) ~= "table" then
		return vmath.vector3(1, 1, 1)
	end
	local source = entry.scale or entry["scale"] or entry[5]
	if type(source) ~= "table" then
		return vmath.vector3(1, 1, 1)
	end
	local x = tonumber(resolve_scale_component(source, "x", 1)) or 1
	local y = tonumber(resolve_scale_component(source, "y", 2)) or 1
	local z = tonumber(resolve_scale_component(source, "z", 3)) or 1
	return vmath.vector3(x, y, z)
end

function System:decode_terrain_entry(entry)
	if type(entry) == "table" then
		if entry.ground ~= nil or entry.shape ~= nil then
			return entry.ground or entry["ground"] or read_numeric_entry(entry, 1) or 0,
				entry.shape or entry["shape"] or read_numeric_entry(entry, 2) or 0,
				decode_entry_color(entry),
				decode_entry_offset(entry),
				decode_entry_scale(entry)
		end
		return read_numeric_entry(entry, 1) or 0,
			read_numeric_entry(entry, 2) or 0,
			decode_entry_color(entry),
			decode_entry_offset(entry),
			decode_entry_scale(entry)
	elseif type(entry) == "number" then
		return entry, 0, vmath.vector4(1, 1, 1, 1), vmath.vector3(0, 0, 0), vmath.vector3(1, 1, 1)
	end
	return 0, 0, vmath.vector4(1, 1, 1, 1), vmath.vector3(0, 0, 0), vmath.vector3(1, 1, 1)
end

local function resolve_color_component(color, ...)
	if not color then return nil end
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		local value
		if type(key) == "number" then
			if type(color) == "table" then
				value = color[key]
			end
		else
			value = color[key]
		end
		if value ~= nil then
			return value
		end
	end
	return nil
end

local function to_color_table(color)
	if not color then return nil end
	local r = LUME.clamp(resolve_color_component(color, "x", "r", 1) or 1, 0, 1)
	local g = LUME.clamp(resolve_color_component(color, "y", "g", 2) or 1, 0, 1)
	local b = LUME.clamp(resolve_color_component(color, "z", "b", 3) or 1, 0, 1)
	local a = LUME.clamp(resolve_color_component(color, "w", "a", 4) or 1, 0, 1)
	return { r, g, b, a }
end

local function to_offset_table(offset)
	if not offset then return nil end
	local x = tonumber(resolve_offset_component(offset, "x", 1)) or 0
	local y = tonumber(resolve_offset_component(offset, "y", 2)) or 0
	local z = tonumber(resolve_offset_component(offset, "z", 3)) or 0
	if x ~= 0 or y ~= 0 or z ~= 0 then
		return { x, y, z }
	end
	return nil
end

local function to_scale_table(scale)
	if not scale then return nil end
	local x = tonumber(resolve_scale_component(scale, "x", 1)) or 1
	local y = tonumber(resolve_scale_component(scale, "y", 2)) or 1
	local z = tonumber(resolve_scale_component(scale, "z", 3)) or 1
	if math.abs(x - 1) < 0.001 and math.abs(y - 1) < 0.001 and math.abs(z - 1) < 0.001 then
		return nil
	end
	return { x, y, z }
end

function System:build_terrain_entry(ground, shape, color, offset, scale)
	ground = math.floor(ground or 0)
	shape = math.floor(shape or 0)
	if ground == 0 and shape == 0 then
		return 0
	end
	local entry = { ground, shape }
	local color_table = to_color_table(color)
	if color_table then
		entry[3] = color_table
	end
	local offset_table = to_offset_table(offset)
	if offset_table then
		entry.offset = offset_table
	end
	local scale_table = to_scale_table(scale)
	if scale_table then
		entry.scale = scale_table
	end
	return entry
end

local function colors_equal(a, b)
	local eps = 0.001
	return math.abs(a.x - b.x) <= eps and
		math.abs(a.y - b.y) <= eps and
		math.abs(a.z - b.z) <= eps and
		math.abs(a.w - b.w) <= eps
end

local function offsets_equal(a, b)
	local eps = 0.0001
	return math.abs(a.x - b.x) <= eps and
		math.abs(a.y - b.y) <= eps and
		math.abs(a.z - b.z) <= eps
end

local function scales_equal(a, b)
	local eps = 0.0001
	return math.abs(a.x - b.x) <= eps and
		math.abs(a.y - b.y) <= eps and
		math.abs(a.z - b.z) <= eps
end

function System:is_same_terrain_entry(a, b)
	local a_type, a_shape, a_color, a_offset, a_scale = self:decode_terrain_entry(a)
	local b_type, b_shape, b_color, b_offset, b_scale = self:decode_terrain_entry(b)
	return a_type == b_type and a_shape == b_shape and
		colors_equal(a_color, b_color) and
		offsets_equal(a_offset, b_offset) and
		scales_equal(a_scale, b_scale)
end

function System:set_terrain_cell_value(index, value)
	local location_data = self:get_location_data()
	if not location_data or not index then return end
	local normalized = location_data:sanitize_terrain_entry(value)
	location_data:set_terrain_cell(index, normalized)
	self.terrain_edit.options_dirty = true
	self:trigger_need_update()
end

function System:get_terrain_cell_components(index)
	local location_data = self:get_location_data()
	if not location_data then return 0, 0, vmath.vector4(1, 1, 1, 1), vmath.vector3(0, 0, 0), vmath.vector3(1, 1, 1) end
	local entry = location_data.data and location_data.data.terrain and location_data.data.terrain[index]
	return self:decode_terrain_entry(entry)
end

function System:get_terrain_cell_from_world(x, z)
	if not terrain or not terrain.world_to_cell or not terrain.coord_to_index then return end
	local gy = -z
	local column, row = terrain.world_to_cell(x, gy)
	if not column or not row then return end
	local zero_index = terrain.coord_to_index(column, row)
	if not zero_index then return end
	return zero_index + 1, column, row
end

function System:update_terrain_selection(index, column, row)
	if not self.terrain_edit then return end
	if not index then
		self.terrain_edit.selected_index = nil
		self.terrain_edit.selected_column = nil
		self.terrain_edit.selected_row = nil
		self.terrain_edit.inspect_color = vmath.vector4(1, 1, 1, 1)
		self.terrain_edit.inspect_offset = vmath.vector3(0, 0, 0)
		self.terrain_edit.inspect_scale = vmath.vector3(1, 1, 1)
		return
	end
	local t, s, c, o, scale = self:get_terrain_cell_components(index)
	self.terrain_edit.selected_index = index
	self.terrain_edit.selected_column = column
	self.terrain_edit.selected_row = row
	self.terrain_edit.inspect_type = t
	self.terrain_edit.inspect_shape = s
	self.terrain_edit.inspect_color = c
	self.terrain_edit.inspect_offset = o or vmath.vector3(0, 0, 0)
	self.terrain_edit.inspect_scale = scale or vmath.vector3(1, 1, 1)
	self.terrain_edit.options_dirty = true
end

function System:paint_terrain_cell(index)
	if not self.terrain_edit then return end
	local entry = self:build_terrain_entry(self.terrain_edit.brush_type, self.terrain_edit.brush_shape, self.terrain_edit.inspect_color,
		self.terrain_edit.inspect_offset, self.terrain_edit.inspect_scale)
	self:change_terrain_cell(index, entry)
end

function System:change_terrain_cell(index, entry)
	local location_data = self:get_location_data()
	if not location_data or not index then return end
	local current = location_data.data and location_data.data.terrain and location_data.data.terrain[index]
	if self:is_same_terrain_entry(current, entry) then return end
	self:execute_command(ChangeTerrainCellCommand.new(self, index, entry))
end

function System:refresh_terrain_value_options()
	if not self.terrain_edit then return end
	local type_options, type_names = build_enum_options(CELLS.TERRAIN_TYPE, function (value)
		return value == CELLS.TERRAIN_TYPE.EMPTY or CELLS.TERRAINS[value] ~= nil
	end)
	local shape_options, shape_names = build_enum_options(CELLS.SHAPES_TYPES, function (value)
		return value == CELLS.SHAPES_TYPES.EMPTY or CELLS.SHAPES[value] ~= nil
	end)
	if #type_options == 0 then
		type_options = { 0 }
		type_names = { [0] = "EMPTY" }
	end
	if #shape_options == 0 then
		shape_options = { 0 }
		shape_names = { [0] = "EMPTY" }
	end
	self.terrain_edit.type_options = type_options
	self.terrain_edit.type_name_by_value = type_names
	self.terrain_edit.shape_options = shape_options
	self.terrain_edit.shape_name_by_value = shape_names
	self.terrain_edit.options_dirty = false
end

function System:update_selected_terrain_type(value)
	if not self.terrain_edit then return end
	self.terrain_edit.inspect_type = value
	if not self.terrain_edit.selected_index then return end
	local entry = self:build_terrain_entry(value, self.terrain_edit.inspect_shape, self.terrain_edit.inspect_color, self.terrain_edit.inspect_offset,
		self.terrain_edit.inspect_scale)
	self:change_terrain_cell(self.terrain_edit.selected_index, entry)
end

function System:update_selected_terrain_shape(value)
	if not self.terrain_edit then return end
	self.terrain_edit.inspect_shape = value
	if not self.terrain_edit.selected_index then return end
	local entry = self:build_terrain_entry(self.terrain_edit.inspect_type, value, self.terrain_edit.inspect_color, self.terrain_edit.inspect_offset,
		self.terrain_edit.inspect_scale)
	self:change_terrain_cell(self.terrain_edit.selected_index, entry)
end

function System:update_selected_terrain_color(value)
	if not self.terrain_edit or not value then return end
	local clamped = vmath.vector4(
		LUME.clamp(resolve_color_component(value, "x", "r", 1) or 1, 0, 1),
		LUME.clamp(resolve_color_component(value, "y", "g", 2) or 1, 0, 1),
		LUME.clamp(resolve_color_component(value, "z", "b", 3) or 1, 0, 1),
		LUME.clamp(resolve_color_component(value, "w", "a", 4) or 1, 0, 1)
	)
	self.terrain_edit.inspect_color = clamped
	if not self.terrain_edit.selected_index then return end
	local entry = self:build_terrain_entry(self.terrain_edit.inspect_type, self.terrain_edit.inspect_shape, clamped, self.terrain_edit.inspect_offset,
		self.terrain_edit.inspect_scale)
	self:change_terrain_cell(self.terrain_edit.selected_index, entry)
end

function System:update_selected_terrain_offset(value)
	if not self.terrain_edit or not value then return end
	local x = tonumber(resolve_offset_component(value, "x", 1)) or 0
	local y = tonumber(resolve_offset_component(value, "y", 2)) or 0
	local z = tonumber(resolve_offset_component(value, "z", 3)) or 0
	local new_offset = vmath.vector3(x, y, z)
	self.terrain_edit.inspect_offset = new_offset
	if not self.terrain_edit.selected_index then return end
	local entry = self:build_terrain_entry(self.terrain_edit.inspect_type, self.terrain_edit.inspect_shape, self.terrain_edit.inspect_color, new_offset,
		self.terrain_edit.inspect_scale)
	self:change_terrain_cell(self.terrain_edit.selected_index, entry)
end

function System:update_selected_terrain_scale(value)
	if not self.terrain_edit or not value then return end
	local x = tonumber(resolve_scale_component(value, "x", 1)) or 1
	local y = tonumber(resolve_scale_component(value, "y", 2)) or 1
	local z = tonumber(resolve_scale_component(value, "z", 3)) or 1
	local clamped = vmath.vector3(
		LUME.clamp(x, TERRAIN_SCALE_SLIDER_MIN, TERRAIN_SCALE_SLIDER_MAX),
		LUME.clamp(y, TERRAIN_SCALE_SLIDER_MIN, TERRAIN_SCALE_SLIDER_MAX),
		LUME.clamp(z, TERRAIN_SCALE_SLIDER_MIN, TERRAIN_SCALE_SLIDER_MAX)
	)
	self.terrain_edit.inspect_scale = clamped
	if not self.terrain_edit.selected_index then return end
	local entry = self:build_terrain_entry(self.terrain_edit.inspect_type, self.terrain_edit.inspect_shape, self.terrain_edit.inspect_color,
		self.terrain_edit.inspect_offset, clamped)
	self:change_terrain_cell(self.terrain_edit.selected_index, entry)
end

function System:terrain_value_selector(display_label, id_suffix, current_value, options, name_by_value)
	imgui.text(display_label)
	imgui.same_line()
	imgui.set_next_item_width(140)
	options = options or { 0 }
	if #options == 0 then
		options = { 0 }
	end
	if current_value == nil then
		current_value = options[1]
	end
	local preview = format_enum_label(current_value, name_by_value)
	local new_value = current_value
	local changed = false
	if imgui.begin_combo("##TerrainValueCombo" .. id_suffix, preview) then
		for _, value in ipairs(options) do
			local selected = value == current_value
			local label = format_enum_label(value, name_by_value)
			if imgui.selectable(label, selected) and value ~= current_value then
				new_value = value
				changed = true
			end
			if selected then imgui.set_item_default_focus() end
		end
		imgui.end_combo()
	end
	imgui.same_line()
	imgui.set_next_item_width(80)
	return changed, new_value
end

---@diagnostic disable-next-line: unused-local
function System:get_ground_position_from_ray(hit_exists, hit_x, hit_y, hit_z)
	if hit_exists then
		return hit_x, hit_z
	end
	local dir = RAYCAST_TO - RAYCAST_FROM
	local denom = dir.y
	if math.abs(denom) < 0.0001 then return end
	local t = -RAYCAST_FROM.y / denom
	if t < 0 then return end
	local pos = RAYCAST_FROM + dir * t
	return pos.x, pos.z
end

function System:handle_terrain_click(hit_exists, hit_x, hit_y, hit_z)
	if not self.terrain_edit or self.terrain_edit.mode == TERRAIN_EDIT_MODE.OFF then return false end
	local world_x, world_z = self:get_ground_position_from_ray(hit_exists, hit_x, hit_y, hit_z)
	if not world_x then return false end
	local index, column, row = self:get_terrain_cell_from_world(world_x, world_z)
	if not index then return false end
	if self.terrain_edit.mode == TERRAIN_EDIT_MODE.SELECT then
		self:update_terrain_selection(index, column, row)
	elseif self.terrain_edit.mode == TERRAIN_EDIT_MODE.PAINT then
		self:paint_terrain_cell(index)
		self:update_terrain_selection(index, column, row)
	end
	return true
end

function System:new_id_for_object()
	local idx = 0
	local exist = true
	local location_data = self.world.game_world.level_creator.location_data
	while exist do
		idx = idx + 1
		local id = "object_" .. idx
		exist = location_data:find_by_id(id)
	end
	return "object_" .. idx
end

function System:new_id_for_clone_object(id)
	local idx = 1
	--local base, num = id:match("(.+)_([0-9]+)$")
	local base, num = id:match("^(.*[^0-9])_?([0-9]*)$")
	if base and num ~= "" then
		local new_num = tonumber(num) + 1
		idx = new_num
	end
	local location_data = self.world.game_world.level_creator.location_data
	while true do
		local new_id = base .. idx
		if not location_data:find_by_id(new_id) then
			return new_id
		end
		idx = idx + 1
	end
	if terrain and terrain.reset_debug_cells_colors then
		terrain.reset_debug_cells_colors()
	end
end

function System:on_remove_from_world()
	self.debug_cells_signature = nil
	if terrain and terrain.reset_debug_cells_colors then
		terrain.reset_debug_cells_colors()
	end
end

function System:get_ground_grid_info()
	local location_data = self.world and self.world.game_world and self.world.game_world.level_creator and self.world.game_world.level_creator.location_data
	if not location_data or not location_data.cells then return end
	local cells_info = location_data.cells
	local cell_size = cells_info.ground_cell_size
	local world_width = cells_info.world_width
	local world_height = cells_info.world_height
	if not cell_size or cell_size == 0 or not world_width or not world_height then return end
	local columns = math.floor(world_width / cell_size + 0.5)
	local rows = math.floor(world_height / cell_size + 0.5)
	if columns <= 0 or rows <= 0 then return end
	return {
		cell_size = cell_size,
		columns = columns,
		rows = rows,
		min_x = -world_width * 0.5,
		min_y = -world_height * 0.5
	}
end

function System:build_terrain_editor_highlight_state()
	if not self.terrain_edit or self.terrain_edit.mode == TERRAIN_EDIT_MODE.OFF then return nil end
	if not self.terrain_edit.selected_column or not self.terrain_edit.selected_row then return nil end
	return {
		type = "cell",
		cell_x = self.terrain_edit.selected_column,
		cell_y = self.terrain_edit.selected_row,
		signature = string.format("terrain_cell:%d:%d", self.terrain_edit.selected_column, self.terrain_edit.selected_row)
	}
end

function System:build_terrain_highlight_state()
	local states = {}
	local cell_state = self:build_terrain_editor_highlight_state()
	local object = self:get_primary_selected_object()
	local grid = self:get_ground_grid_info()
	if object and grid and object.is_island and object.ground_min_x ~= nil and object.ground_max_x ~= nil
		and object.ground_min_y ~= nil and object.ground_max_y ~= nil then
		local min_x = math.floor(math.min(object.ground_min_x, object.ground_max_x))
		local max_x = math.floor(math.max(object.ground_min_x, object.ground_max_x))
		local min_y = math.floor(math.min(object.ground_min_y, object.ground_max_y))
		local max_y = math.floor(math.max(object.ground_min_y, object.ground_max_y))
		min_x = LUME.clamp(min_x, 0, grid.columns - 1)
		max_x = LUME.clamp(max_x, min_x, grid.columns - 1)
		min_y = LUME.clamp(min_y, 0, grid.rows - 1)
		max_y = LUME.clamp(max_y, min_y, grid.rows - 1)
		table.insert(states, {
			type = "island",
			min_x = min_x,
			max_x = max_x,
			min_y = min_y,
			max_y = max_y,
			signature = string.format("island:%s:%d:%d:%d:%d", object.id, min_x, max_x, min_y, max_y)
		})
	end
	if cell_state then
		table.insert(states, cell_state)
	end
	if #states == 0 then return nil end
	local signature_parts = {}
	for i = 1, #states do
		signature_parts[i] = states[i].signature
	end
	return {
		type = "group",
		states = states,
		signature = table.concat(signature_parts, "|")
	}
end

function System:apply_terrain_highlight(state)
	if not terrain or not terrain.set_debug_cell_color then return end
	if state.type == "group" and state.states then
		for i = 1, #state.states do
			self:apply_terrain_highlight(state.states[i])
		end
	elseif state.type == "island" then
		for x = state.min_x, state.max_x do
			for y = state.min_y, state.max_y do
				terrain.set_debug_cell_color(x, y, COLOR_TERRAIN_ISLAND_CELL.x, COLOR_TERRAIN_ISLAND_CELL.y,
					COLOR_TERRAIN_ISLAND_CELL.z, COLOR_TERRAIN_ISLAND_CELL.w)
			end
		end
	elseif state.type == "cell" then
		terrain.set_debug_cell_color(state.cell_x, state.cell_y, COLOR_TERRAIN_SELECTED_CELL.x, COLOR_TERRAIN_SELECTED_CELL.y,
			COLOR_TERRAIN_SELECTED_CELL.z, COLOR_TERRAIN_SELECTED_CELL.w)
	end
end

function System:update_terrain_debug_highlight()
	if not terrain or not terrain.reset_debug_cells_colors or not terrain.set_debug_cell_color then
		return
	end
	local state = self:build_terrain_highlight_state()
	if not state then
		if self.debug_cells_signature then
			self.debug_cells_signature = nil
			print("reset cells")
			terrain.reset_debug_cells_colors()
		end
		return
	end
	local signature = state.signature
	if self.debug_cells_signature ~= signature then
		self.debug_cells_signature = signature
		terrain.reset_debug_cells_colors()
	end
	self:apply_terrain_highlight(state)
end

function System:update_spawner_selection_area(entity)
	if not entity or not entity.object_config then return end
	local def =DEF_OBJECTS.BY_ID[entity.object_config.type]
	if not def or def.id ~=DEF_OBJECTS.TYPES.COMMON.OBJECTS.SPAWNER.id then return end
	if not entity.editor_spawner_area_go then
		entity.editor_spawner_area_go = CubeAreaGo.new()
		entity.editor_spawner_area_go:set_color(COLOR_SPAWNER_AREA)
	end
	entity.editor_spawner_area_go:set_size(entity.object_config.scale.x, entity.object_config.scale.y, entity.object_config.scale.z)
	entity.editor_spawner_area_go:set_position(entity.position.x, entity.position.y, entity.position.z)
end

function System:remove_spawner_selection_area(entity)
	if entity and entity.editor_spawner_area_go then
		entity.editor_spawner_area_go:dispose()
		entity.editor_spawner_area_go = nil
	end
end

function System:apply_highlight_to_entity(entity)
	if not entity then return end
	if entity.object_go then
		for i = 1, #entity.object_go.models do
			local model_go = entity.object_go.models[i]
			LUME.mix_color(TEMP_V4, model_go.tint, TINT_SELECTED, 0.1)
			go.set(model_go.model, HASHES.TINT, TEMP_V4)
		end
	end
	self:update_spawner_selection_area(entity)
end

function System:clear_highlight_from_entity(entity)
	if not entity then return end
	if entity.object_go then
		for i = 1, #entity.object_go.models do
			local model_go = entity.object_go.models[i]
			go.set(model_go.model, HASHES.TINT, model_go.tint)
		end
	end
	self:remove_spawner_selection_area(entity)
end

function System:update_selection_visuals()
	local desired = {}
	for i = 1, #self.selected_objects do
		local object = self.selected_objects[i]
		local entity = self:find_entity_by_id(object.id)
		if entity then
			desired[entity] = true
		end
	end

	for entity in pairs(self.highlighted_entities) do
		if not desired[entity] or not entity.object_go then
			self:clear_highlight_from_entity(entity)
			self.highlighted_entities[entity] = nil
		end
	end

	for entity in pairs(desired) do
		if not self.highlighted_entities[entity] then
			self:apply_highlight_to_entity(entity)
			self.highlighted_entities[entity] = true
		end
		self:update_spawner_selection_area(entity)
	end

	local primary = self:get_primary_selected_object()
	if primary then
		local entity = self:find_entity_by_id(primary.id)
		if entity then
			msg.post("@render:", "draw_line", {
				start_point = entity.position,
				end_point = self.world.game_world.level_creator.player.position + vmath.vector3(0, 2, 0),
				color = COLOR_RAY_TO_SELECTED })
		end
	end
end

function System:clone_selection(selection)
	local copy = {}
	if not selection then return copy end
	for i = 1, #selection do
		copy[i] = selection[i]
	end
	return copy
end

function System:set_selected_objects(selection)
	self.selected_objects = self:clone_selection(selection)
	self.selected_objects_map = {}
	for i = 1, #self.selected_objects do
		local object = self.selected_objects[i]
		if object then
			self.selected_objects_map[object.id] = i
		end
	end
	--self.debug_cells_signature = nil
end

function System:get_selection_snapshot()
	return self:clone_selection(self.selected_objects)
end

function System:get_primary_selected_object()
	return self.selected_objects[1]
end

function System:is_object_selected(object)
	if not object then return false end
	return self.selected_objects_map[object.id] ~= nil
end

function System:is_multi_select_modifier_active()
	return INPUT.get_key_data(HASHES.INPUT.LEFT_SHIFT).pressed or INPUT.get_key_data(HASHES.INPUT.LEFT_CTRL).pressed
end

function System:build_selection_result(object, additive)
	if not additive then
		return object and { object } or {}
	end
	local result = self:get_selection_snapshot()
	if not object then
		return result
	end
	local idx = self.selected_objects_map[object.id]
	if idx then
		table.remove(result, idx)
	else
		table.insert(result, object)
	end
	return result
end

function System:is_same_selection(selection)
	selection = selection or {}
	local current = self.selected_objects or {}
	if #current ~= #selection then return false end
	for i = 1, #current do
		if current[i] ~= selection[i] then
			return false
		end
	end
	return true
end

function System:get_selection_signature()
	if not self.selected_objects or #self.selected_objects == 0 then
		return nil
	end
	local ids = {}
	for i = 1, #self.selected_objects do
		ids[i] = self.selected_objects[i].id
	end
	return table.concat(ids, "|")
end

function System:calculate_group_matrix()
	local count = #self.selected_objects
	if count == 0 then return MATRIX_IDENTITY end
	local location_data = self.world.game_world.level_creator.location_data
	if count == 1 then
		return vmath.matrix4(location_data:get_world_transform(self.selected_objects[1].id))
	end
	local center = vmath.vector3()
	local position = vmath.vector3()
	local temp_rotation = vmath.quat()
	local scale = vmath.vector3()
	local first_rotation = vmath.quat()
	for i = 1, count do
		local matrix = location_data:get_world_transform(self.selected_objects[i].id)
		xmath.matrix_get_transforms(matrix, position, scale, temp_rotation)
		center.x = center.x + position.x
		center.y = center.y + position.y
		center.z = center.z + position.z
		if i == 1 then
			first_rotation = vmath.quat(temp_rotation)
		end
	end
	center.x = center.x / count
	center.y = center.y / count
	center.z = center.z / count
	local group_matrix = vmath.matrix4()
	local basis_rotation = QUAT_Z0
	if self.gizmo.mode == imgui.ImGuiGizmo_MODE_LOCAL then
		basis_rotation = first_rotation
	end
	xmath.matrix_from_transforms(group_matrix, center, SCALE_1, basis_rotation)
	return group_matrix
end

function System:apply_multi_gizmo(delta_matrix, base_matrix)
	local selection = self:get_selection_snapshot()
	if #selection == 0 then return end
	local location_data = self.world.game_world.level_creator.location_data
	local transforms = {}
	local target_matrix = delta_matrix * base_matrix
	local base_inverse = vmath.inv(base_matrix)
	local new_position = vmath.vector3()
	local new_scale = vmath.vector3()
	local new_rotation = vmath.quat()
	for i = 1, #selection do
		local object = selection[i]
		local object_world = location_data:get_world_transform(object.id)
		local relative = base_inverse * object_world
		local new_world = target_matrix * relative
		local parent_matrix = object.parent and location_data:get_world_transform(object.parent) or MATRIX_IDENTITY
		local object_local = vmath.inv(parent_matrix) * new_world
		xmath.matrix_get_transforms(object_local, new_position, new_scale, new_rotation)
		local entry = {
			position = vmath.vector3(new_position),
		}
		if self.gizmo.operation == imgui.ImGuiGizmo_OPERATION_ROTATE then
			entry.rotation = vmath.quat(new_rotation)
		elseif self.gizmo.operation == imgui.ImGuiGizmo_OPERATION_SCALE then
			entry.scale = vmath.vector3(new_scale)
		end
		transforms[object.id] = entry
	end
	self:execute_command(TransformSelectionCommand.new(self, {
		selection = selection,
		operation = self.gizmo.operation,
		transforms = transforms
	}))
end

function System:cleanup_selected_objects()
	if not self.selected_objects or #self.selected_objects == 0 then return end
	local location_data = self.world and self.world.game_world and self.world.game_world.level_creator and self.world.game_world.level_creator.location_data
	if not location_data then return end
	local changed = false
	for i = #self.selected_objects, 1, -1 do
		local object = self.selected_objects[i]
		if not object or not location_data:find_by_id(object.id) then
			table.remove(self.selected_objects, i)
			changed = true
		end
	end
	if changed then
		self.selected_objects_map = {}
		for i = 1, #self.selected_objects do
			self.selected_objects_map[self.selected_objects[i].id] = i
		end
	end
end

function System:select_object(object)
	local selection = {}
	if object then
		selection[1] = object
	end
	self:set_selected_objects(selection)
end

function System:draw_spawner_config_ui(selected_object)
	if not selected_object then return end
	local def =DEF_OBJECTS.BY_ID[selected_object.type]
	if not def or def.id ~=DEF_OBJECTS.TYPES.COMMON.OBJECTS.SPAWNER.id then return end
	local spawner_config = build_spawner_config_view(selected_object.spawner_config)
	imgui.separator()
	imgui.text("Spawner Config")
	local function commit_spawner_config()
		self:execute_command(ChangeSpawnerConfigCommand.new(self, selected_object, spawner_config))
		spawner_config = build_spawner_config_view(selected_object.spawner_config)
	end
	if imgui.button("Reset##SpawnerReset") then
		local objects_backup = LUME.clone_deep(spawner_config.objects or {})
		spawner_config = build_spawner_config_view(nil)
		spawner_config.objects = objects_backup
		commit_spawner_config()
	end

	local changed, value = imgui.input_int("Max spawned##SpawnerMax", spawner_config.max_spawned or DEFAULT_SPAWNER_CONFIG.max_spawned)
	if changed then
		spawner_config.max_spawned = math.max(1, value)
		commit_spawner_config()
	end

	changed, value = imgui.input_float("Spawn delay##SpawnerDelay", spawner_config.spawn_delay or DEFAULT_SPAWNER_CONFIG.spawn_delay, 0, 0, "%.2f")
	if changed then
		spawner_config.spawn_delay = math.max(0, value)
		commit_spawner_config()
	end

	changed, value = imgui.input_float("Spawn delay delta##SpawnerDelayDelta", spawner_config.spawn_delay_delta or DEFAULT_SPAWNER_CONFIG.spawn_delay_delta, 0, 0, "%.2f")
	if changed then
		spawner_config.spawn_delay_delta = math.max(0, value)
		commit_spawner_config()
	end

	changed, value = imgui.input_float("Initial delay##SpawnerInitialDelay", spawner_config.initial_delay or DEFAULT_SPAWNER_CONFIG.initial_delay, 0, 0, "%.2f")
	if changed then
		spawner_config.initial_delay = math.max(0, value)
		commit_spawner_config()
	end

	changed, value = imgui.input_float("Time scale on empty##SpawnerTimeScaleOnEmpty", spawner_config.time_scale_on_empty or DEFAULT_SPAWNER_CONFIG.time_scale_on_empty, 0, 0, "%.2f")
	if changed then
		spawner_config.time_scale_on_empty = math.max(0, value)
		commit_spawner_config()
	end


	imgui.separator()
	imgui.text("Spawned Objects")
	local spawnable_list = BUILDABLES.SPAWNED_OBJECTS_LIST
	if not spawnable_list or #spawnable_list == 0 then
		imgui.text("No spawnable objects configured. Update buildables.lua.")
	else
		local remove_index = nil
		for i = 1, #(spawner_config.objects or {}) do
			local entry = spawner_config.objects[i]
			imgui.push_id("SpawnerObject" .. i)
			local label = entry.object_id or "Select object"
			if imgui.begin_combo("Object##SpawnerObject", label) then
				for _, spawnable in ipairs(spawnable_list) do
					local spawnable_def = DEFS.BUILDABLES.BY_ID[spawnable]
					local is_selected = spawnable_def.id == entry.object_id
					if imgui.selectable(spawnable_def.id, is_selected) then
						if not is_selected then
							entry.object_id = spawnable_def.id
							commit_spawner_config()
						end
					end
					if is_selected then imgui.set_item_default_focus() end
				end
				imgui.end_combo()
			end
			local weight = entry.weight or 0
			changed, value = imgui.input_float("Weight##SpawnerWeight", weight, 0, 0, "%.2f")
			if changed then
				entry.weight = math.max(0, value)
				commit_spawner_config()
			end
			if imgui.button("Remove##SpawnerRemove") then
				remove_index = i
			end
			imgui.separator()
			imgui.pop_id()
			if remove_index then
				break
			end
		end
		if remove_index then
			table.remove(spawner_config.objects, remove_index)
			commit_spawner_config()
		end
		if imgui.button("Add spawn object##SpawnerAdd") then
			local default_object = spawnable_list[1]
			if default_object then
				spawner_config.objects = spawner_config.objects or {}
				table.insert(spawner_config.objects, { object_id = default_object, weight = 1 })
				commit_spawner_config()
			end
		end
	end
end

function System:draw_object_ui()
	local changed, value = false, nil
	local location_data = self.world.game_world.level_creator.location_data
	local selected_object = self:get_primary_selected_object()

	if selected_object and (not self.terrain_edit or self.terrain_edit.mode == TERRAIN_EDIT_MODE.OFF) then
		local object_cfg = selected_object
		local selection_signature = self:get_selection_signature()
		local selection_count = #self.selected_objects
		local parent_matrix = object_cfg.parent and location_data:get_world_transform(object_cfg.parent) or MATRIX_IDENTITY
		local base_matrix
		if selection_count > 1 then
			if self.gizmo.id ~= selection_signature or not imgui.gizmo_is_using_any() then
				self.gizmo.id = selection_signature
				self.gizmo_matrix = self:calculate_group_matrix()
			end
			base_matrix = self.gizmo_matrix
		else
			if self.gizmo.id ~= selection_signature or not imgui.gizmo_is_using_any() then
				self.gizmo.id = selection_signature
				self.gizmo_matrix = vmath.matrix4(location_data:get_world_transform(object_cfg.id))
			end
			base_matrix = self.gizmo_matrix

			--strange error with translate if rotation 180
			if self.gizmo.operation ~= imgui.ImGuiGizmo_OPERATION_TRANSLATE then
				base_matrix = vmath.matrix4(location_data:get_world_transform(object_cfg.id))
			end
		end

		local delta_matrix
		changed, delta_matrix = imgui.gizmo("selected_gizmo#selected_gizmo", self.gizmo.mode, self.gizmo.operation, RENDER.view, RENDER.proj,
			base_matrix)
		if changed then
			local target_matrix = delta_matrix * base_matrix
			self.gizmo_matrix = target_matrix
			local new_position = vmath.vector3()
			local new_rotation = vmath.quat()
			local new_scale = vmath.vector3()
			xmath.matrix_get_transforms(delta_matrix, new_position, new_scale, new_rotation)
			new_position.x = new_position.x * (1 / new_scale.x)
			new_position.y = new_position.y * (1 / new_scale.y)
			new_position.z = new_position.z * (1 / new_scale.z)
			xmath.matrix_from_transforms(delta_matrix, new_position, new_scale, new_rotation)

			if selection_count > 1 then
				self:apply_multi_gizmo(delta_matrix, base_matrix)
			else
				local object_local = vmath.inv(parent_matrix) * target_matrix
				xmath.matrix_get_transforms(object_local, new_position, new_scale, new_rotation)
				if self.gizmo.operation == imgui.ImGuiGizmo_OPERATION_TRANSLATE then
					self:execute_command(ChangePositionObjectCommand.new(self, selected_object, new_position))
				elseif self.gizmo.operation == imgui.ImGuiGizmo_OPERATION_ROTATE then
					self:execute_command(ChangeRotationObjectCommand.new(self, selected_object, new_rotation))
				elseif self.gizmo.operation == imgui.ImGuiGizmo_OPERATION_SCALE then
					self:execute_command(ChangeScaleObjectCommand.new(self, selected_object, vmath.mul_per_elem(object_cfg.scale, new_scale)))
				end
				self:object_changed(object_cfg.id)
			end
		end
	end

	imgui.begin_window("Object", false, imgui.WINDOWFLAGS_MENUBAR)

	local gizmo_disabled = self.terrain_edit and self.terrain_edit.mode ~= TERRAIN_EDIT_MODE.OFF
	if gizmo_disabled then
		imgui.text("Gizmo disabled in terrain edit mode.")
	else
		if imgui.button("Translate", 80, 40) then
			self.gizmo.operation = imgui.ImGuiGizmo_OPERATION_TRANSLATE
		end
		imgui.same_line()
		if imgui.button("Rotate", 80, 40) then
			self.gizmo.operation = imgui.ImGuiGizmo_OPERATION_ROTATE
		end
		imgui.same_line()
		if imgui.button("Scale", 80, 40) then
			self.gizmo.operation = imgui.ImGuiGizmo_OPERATION_SCALE
		end
		imgui.same_line()
		changed, value = imgui.checkbox("World", self.gizmo.mode == imgui.ImGuiGizmo_MODE_WORLD)
		if changed then
			self.gizmo.mode = value and imgui.ImGuiGizmo_MODE_WORLD or imgui.ImGuiGizmo_MODE_LOCAL
		end
	end

	if imgui.button("CLONE", 100, 40) then
		if selected_object then
			self:execute_command(CloneObjectCommand.new(self, selected_object))
		end
	end


	if not selected_object then
		imgui.text("NO OBJECT SELECTED")
		imgui.end_window()
		return
	end

	local object_cfg = selected_object
	local text, x, y, z, w = "", 0, 0, 0, 0

	imgui.same_line()
	if imgui.button("DELETE", 100, 40) then
		if selected_object then
			self:execute_command(DeleteObjectCommand.new(self, selected_object))
		end
	end
	imgui.same_line()
	if imgui.button("DELETE RECURSIVE", 170, 40) then
		if selected_object then
			self:execute_command(DeleteRecursiveCommand.new(self, selected_object))
		end
	end

	changed, text = imgui.input_text("Id:##id_" .. tostring(object_cfg), object_cfg.id)
	if changed then
		self:execute_command(ChangeIdCommand.new(self, selected_object, text))
	end

	if imgui.button("Parent##open_parent", 120, 20) then
		if object_cfg.parent then
			local parent_object = location_data.object_by_id[object_cfg.parent]
			if parent_object then
				self:execute_command(SelectObjectCommand.new(self, { parent_object }))
			end
		end
	end


	if imgui.begin_combo("type##items_id", object_cfg.type) then
		for i = 1, #DEFS.OBJECTS.OBJECTS_LIST do
			if imgui.selectable(DEFS.OBJECTS.OBJECTS_LIST[i],DEF_OBJECTS.OBJECTS_LIST[i] == object_cfg.type) then
				if object_cfg.type ~=DEF_OBJECTS.OBJECTS_LIST[i] then
					self:execute_command(ChangeTypeObjectCommand.new(self, selected_object,DEF_OBJECTS.OBJECTS_LIST[i]))
				end
			end
			ifDEF_OBJECTS.OBJECTS_LIST[i] == object_cfg.type then
				imgui.set_item_default_focus()
			end
		end
		imgui.end_combo()
	end

	changed, x, y, z = imgui.input_float3("Position##ObjectPosition", object_cfg.position.x, object_cfg.position.y, object_cfg.position.z)
	if changed then
		self:execute_command(ChangePositionObjectCommand.new(self, selected_object, vmath.vector3(x, y, z)))
	end

	xmath.quat_to_euler(TEMP_V, object_cfg.rotation)
	changed, x, y, z = imgui.input_float3("Rotation##ObjectRotation", TEMP_V.x, TEMP_V.y, TEMP_V.z)
	if changed then
		xmath.vector3_set_components(TEMP_V, x, y, z)
		local quat = vmath.quat_rotation_x(0)
		xmath.euler_to_quat(quat, TEMP_V)
		self:execute_command(ChangeRotationObjectCommand.new(self, selected_object, quat))
	end

	changed, x, y, z = imgui.input_float3("Scale##ObjectScale", object_cfg.scale.x, object_cfg.scale.y, object_cfg.scale.z)
	if changed and x > 0 and y > 0 and z > 0 then
		self:execute_command(ChangeScaleObjectCommand.new(self, selected_object, vmath.vector3(x, y, z)))
	end

	changed, x, y, z, w = imgui.input_float4("Tint##ObjectTint", object_cfg.tint.x, object_cfg.tint.y, object_cfg.tint.z, object_cfg.tint.w)
	if changed then
		local v4 = vmath.vector4(LUME.clamp(x, 0, 1), LUME.clamp(y, 0, 1), LUME.clamp(z, 0, 1), LUME.clamp(w, 0, 1))
		self:execute_command(ChangeTintObjectCommand.new(self, selected_object, v4))
	end

	if object_cfg.type ==DEF_OBJECTS.TYPES.CUBES.OBJECTS.STONE_BLOCKER_1.id then
		if not object_cfg.difficulty then
			object_cfg.difficulty = 1
		end
		changed, x = imgui.input_int("Difficulty##ObjectDifficulty" .. object_cfg.id, object_cfg.difficulty)
		if changed then
			self:execute_command(ChangeDifficultyObjectCommand.new(self, selected_object, x))
		end
	end

	if object_cfg.type ==DEF_OBJECTS.TYPES.OBJECT.OBJECTS.SKIN_PLACE.id or object_cfg.type ==DEF_OBJECTS.TYPES.OBJECT.OBJECTS.SKIN_PICKUP.id or object_cfg.type ==DEF_OBJECTS.TYPES.OBJECT.OBJECTS.SKIN_IDLE.id then
		if not object_cfg.skin then
			object_cfg.skin = DEFS.SKINS.PLAYER_LIST_SKINS[1].id
		end
		if imgui.begin_combo("skin##skin_id" .. object_cfg.id, object_cfg.skin) then
			for i = 1, #DEFS.SKINS.PLAYER_LIST_SKINS do
				if imgui.selectable(DEFS.SKINS.PLAYER_LIST_SKINS[i].id, DEFS.SKINS.PLAYER_LIST_SKINS[i].id == object_cfg.skin) then
					if object_cfg.skin ~= DEFS.SKINS.PLAYER_LIST_SKINS[i].id then
						self:execute_command(ChangeSkinObjectCommand.new(self, selected_object, DEFS.SKINS.PLAYER_LIST_SKINS[i].id))
					end
				end
			end
			imgui.end_combo()
		end
		if object_cfg.type ==DEF_OBJECTS.TYPES.OBJECT.OBJECTS.SKIN_PLACE.id then
			local direction = object_cfg.direction or 1

			if imgui.begin_combo("Direction##direction_id" .. object_cfg.id, DIRECTIONS[direction].name) then
				for i = 1, #DIRECTIONS do
					if imgui.selectable(DIRECTIONS[i].name, DIRECTIONS[i].direction == direction) then
						if object_cfg.direction ~= DIRECTIONS[i].direction then
							self:execute_command(ChangeDirectionObjectCommand.new(self, selected_object, DIRECTIONS[i].direction))
						end
					end
				end
				imgui.end_combo()
			end
		end
	end

	changed, value = imgui.input_float("Location Percent##LocationPercent", object_cfg.location_percent or 0)
	if changed then
		self:execute_command(ChangeLocationPercentCommand.new(self, object_cfg, value))
	end

	self:draw_spawner_config_ui(object_cfg)

	changed, x = imgui.checkbox("Need button##Need button", object_cfg.need_button)
	if changed then
		self:execute_command(ChangeNeedButtonObjectCommand.new(self, object_cfg, x))
	end

	changed, x = imgui.checkbox("Is island##Is islands" .. object_cfg.id, object_cfg.is_island)
	if changed then
		self:execute_command(ChangeIsIslandObjectCommand.new(self, object_cfg, x))
	end

	if object_cfg.is_island then
		local ground_min_x = object_cfg.ground_min_x or 0
		local ground_max_x = object_cfg.ground_max_x or 0
		local ground_min_y = object_cfg.ground_min_y or 0
		local ground_max_y = object_cfg.ground_max_y or 0

		changed, x = imgui.input_int("Ground min X##ground_min_x" .. object_cfg.id, ground_min_x)
		if changed then
			self:execute_command(ChangeGroundMinXObjectCommand.new(self, object_cfg, x))
		end
		changed, x = imgui.input_int("Ground max X##ground_max_x" .. object_cfg.id, ground_max_x)
		if changed then
			self:execute_command(ChangeGroundMaxXObjectCommand.new(self, object_cfg, x))
		end
		changed, x = imgui.input_int("Ground min Y##ground_min_y" .. object_cfg.id, ground_min_y)
		if changed then
			self:execute_command(ChangeGroundMinYObjectCommand.new(self, object_cfg, x))
		end
		changed, x = imgui.input_int("Ground max Y##ground_max_y" .. object_cfg.id, ground_max_y)
		if changed then
			self:execute_command(ChangeGroundMaxYObjectCommand.new(self, object_cfg, x))
		end
	end


	if object_cfg.need_button then
		if imgui.begin_combo("price_id##price_id" .. object_cfg.id, object_cfg.price_id or "") then
			for i = 1, #DEFS.PRICES.LIST do
				local price = DEFS.PRICES.LIST[i]
				if imgui.selectable(price.id, price.id == object_cfg.skin) then
					if object_cfg.price_id ~= price.id then
						self:execute_command(ChangePriceIdObjectCommand.new(self, selected_object, price.id))
					end
				end
			end
			imgui.end_combo()
		end

		if object_cfg.price_id then
			local price = DEFS.PRICES.BY_ID[object_cfg.price_id]
			imgui.input_int("Cost##ObjectCost" .. object_cfg.id, price.price)
			imgui.input_int("Income##ObjectIncome" .. object_cfg.id, object_cfg.income)
		else

		end

		imgui.text("requirements")
		for i = 1, 3 do
			local requirement = object_cfg.requirements[i]
			changed = false
			local blocked = requirement and not location_data:is_build(requirement)
			local requirement_color = blocked and COLOR_BLOCKED or COLOR_UNBLOCKED
			imgui.push_style_color(imgui.ImGuiCol_Text, requirement_color.x, requirement_color.y, requirement_color.z, requirement_color.w)

			if imgui.begin_combo("##requirement_" .. i, requirement or "") then
				imgui.pop_style_color()
				imgui.push_style_color(imgui.ImGuiCol_Text, COLOR_UNBLOCKED.x, COLOR_UNBLOCKED.y, COLOR_UNBLOCKED.z, COLOR_UNBLOCKED.w)
				if imgui.selectable("##empty", not requirement) then
					if requirement then
						self:execute_command(ChangeRequirmentsObjectCommand.new(self, selected_object, i, nil))

						changed = true
					end
				end
				imgui.pop_style_color()
				if not changed then
					for j = 1, #self.objects_list do
						local object = self.objects_list[j]
						if object.id ~= object_cfg.id and object.need_button and object.cost > 0 then
							blocked = not location_data:is_build(object.id)
							requirement_color = blocked and COLOR_BLOCKED or COLOR_UNBLOCKED
							imgui.push_style_color(imgui.ImGuiCol_Text, requirement_color.x, requirement_color.y, requirement_color.z, requirement_color.w)
							if imgui.selectable(object.id .. "##requirement_" .. i .. "_" .. object.id, object.id == requirement) then
								if object_cfg.requirements[i] ~= object.id then
									self:execute_command(ChangeRequirmentsObjectCommand.new(self, selected_object, i, object.id))
									imgui.pop_style_color()
									break
								end
							end
							imgui.pop_style_color()
						end
					end
				end
				imgui.end_combo()
			else
				imgui.pop_style_color()
			end
		end
		changed, x, y, z = imgui.input_float3("Button position##ObjectButtonPosition", object_cfg.button_position.x, object_cfg.button_position.y,
			object_cfg.button_position.z)
		if changed then
			self:execute_command(ChangeButtonPositionObjectCommand.new(self, selected_object, vmath.vector3(x, y, z)))
		end

		changed, x = imgui.checkbox("Button##checkbox", self.button_show)
		if changed then
			self:execute_command(ChangeButtonShowObjectCommand.new(self, x))
		end
	end

	imgui.end_window()
end

function System:object_changed(id)
	local location_data = self.world.game_world.level_creator.location_data
	local object = location_data:find_by_id(id)
	if not object then return end

	location_data:transform_changed(id)
	local entity = self:find_entity_by_id(id)
	print("no entity with id:" .. id)
	if entity then
		self.world:remove_entity(entity)
		if entity.button_entity then
			self.world:remove_entity(entity.button_entity)
		end
	end
	---@class Entity
	--if object.type ~=DEF_OBJECTS.TYPES.COMMON.OBJECTS.EMPTY.id then
	local e = nil
	for _, e2c in ipairs(self.world.entities_to_change) do
		if e2c.object_config and e2c.object_config.id == id then
			e = e2c
			break
		end
	end
	if not e then
		e = self.world.game_world.ecs.entities:create_object(object)
		self.world:add_entity(e)
	end

	location_data:trigger_location_changed()
	--end

	local tree = self.objects_tree_map[object.id]
	for _, children in ipairs(tree.childrens) do
		self:object_changed(children.object.id)
	end
end

function System:select_object_raycast()
	if INPUT.TOUCH then
		self.touch_action = INPUT.TOUCH
	end
	if IMGUI.is_imgui_handled_input() then
		self.touch_action = nil
	end
	if not INPUT.TOUCH and self.touch_action then
		local action = self.touch_action
		self.touch_action = nil
		local time = socket.gettime() - INPUT.get_key_data(HASHES.INPUT.TOUCH).pressed_time
		if time < 0.15 then
			CAMERAS.CAMERAS.GAME:screen_to_world_ray_to_vector3(action.screen_x, action.screen_y, RAYCAST_FROM, RAYCAST_TO)
			local hit, hx, hy, hz, _, _, _, id = game.physics_raycast_single(RAYCAST_FROM, RAYCAST_TO, self.raycast_mask)
			if self:handle_terrain_click(hit, hx, hy, hz) or (self.terrain_edit and self.terrain_edit.mode ~= TERRAIN_EDIT_MODE.OFF) then
				return
			end
			if hit and id then
				local e = self.world.game_world.ecs.entities.collision_to_object[id]
				if e and e.object_config_e then
					e = e.object_config_e
				end
				if e then
					local additive = self:is_multi_select_modifier_active()
					local selection = self:build_selection_result(e.object_config, additive)
					if not self:is_same_selection(selection) then
						self:execute_command(SelectObjectCommand.new(self, selection))
					end
				end
			else
				if #self.selected_objects > 0 then
					self:execute_command(SelectObjectCommand.new(self, {}))
				end
			end
		end
	end
end

function System:draw()
	if not self.world.game_world.state.editor_visible then return end
	if not self.world then return end
	if not imgui then return end
	if INPUT.get_key_data(HASHES.INPUT.T).pressed then
		self.gizmo.operation = imgui.ImGuiGizmo_OPERATION_TRANSLATE
	elseif INPUT.get_key_data(HASHES.INPUT.Y).pressed then
		self.gizmo.operation = imgui.ImGuiGizmo_OPERATION_ROTATE
	elseif INPUT.get_key_data(HASHES.INPUT.U).pressed then
		self.gizmo.operation = imgui.ImGuiGizmo_OPERATION_SCALE
	elseif INPUT.get_key_data(HASHES.INPUT.I).just_pressed then
		self.gizmo.mode = self.gizmo.mode == imgui.ImGuiGizmo_MODE_LOCAL and imgui.ImGuiGizmo_MODE_WORLD or imgui.ImGuiGizmo_MODE_LOCAL
	end
	self:select_object_raycast()
	self:draw_history_ui()
	self:draw_location_ui()
	self:draw_terrain_ui()
	self:draw_object_ui()
	self:update_selected_object_button()
	self:update_selection_visuals()
	self:update_terrain_debug_highlight()

	if INPUT.get_key_data(HASHES.INPUT.LEFT_CTRL).pressed and INPUT.get_key_data(HASHES.INPUT.Z).just_pressed then
		self:undo()
	end
end

return System
