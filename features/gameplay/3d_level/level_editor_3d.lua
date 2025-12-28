local CLASS = require "libs.class"
local ECS = require 'libs.ecs'
local LUME = require "libs.lume"
local INPUT = require "features.core.input.input"
local HASHES = require "libs.hashes"
local CAMERAS = require "features.core.camera.cameras_feature"
local IMGUI = require "features.debug.imgui.imgui_feature"
local ENUMS = require "game.enums"
local LevelEditor3dFeature = require "features.gameplay.3d_level.level_editor_3d_feature"

local DEF_OBJECTS = require "features.gameplay.3d_level.level_objects_def"

local RAYCAST_FROM = vmath.vector3()
local RAYCAST_TO = vmath.vector3()
local TEMP_V = vmath.vector3()
local TEMP_V4 = vmath.vector4()

local SCALE_1 = vmath.vector3(1, 1, 1)

local QUAT_Z0 = vmath.quat_rotation_z(0)

local MATRIX_IDENTITY = vmath.matrix4()

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

local ChangeObjectTypeFilterCommand = CLASS.class("ChangeObjectTypeFilterCommand", Command)
function ChangeObjectTypeFilterCommand.new(system, value)
	return CLASS.new_instance(ChangeObjectTypeFilterCommand, system, value)
end

function ChangeObjectTypeFilterCommand:execute()
	self.value_saved = self.system.object_type_filter
	self.system.object_type_filter = self.value
end

function ChangeObjectTypeFilterCommand:undo()
	self.system.object_type_filter = self.value_saved
end

function ChangeObjectTypeFilterCommand:merge(command)
	Command.merge(self, command)
	self.value = command.value
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
		type = DEF_OBJECTS.TYPES.COMMON.OBJECTS.CUBE_1.id,
		scale = vmath.vector3(1, 1, 1),
		position = self.object and vmath.vector3(0) or vmath.vector3(self.system.world.game_world.level_creator.player.position) + vmath.vector3(0, 0, -1),
		rotation = vmath.quat_rotation_z(0),
		tint = vmath.vector4(1, 1, 1, 1),
		requirements = {},
		parent = self.object and self.object.id,
		skin = "default"
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
	return CLASS.new_instance(ChangeValueObjectCommand, system, object, field, value)
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

local ChangeSkinObjectCommand = CLASS.class("ChangeSkinObjectCommand", ChangeValueObjectCommand)
function ChangeSkinObjectCommand.new(system, object, value)
	return CLASS.new_instance(ChangeSkinObjectCommand, system, object, "skin", value)
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
local System = CLASS.class("LevelEditor3dSystem", ECS.System)

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

	self.object_type_filter = "ALL"
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

	if (imgui.begin_dragdrop_target()) then
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

	---@diagnostic disable-next-line: unused-local
	local changed, value, x, y, z = false, false, 0, 0, 0
	---@diagnostic disable-next-line: unused-local
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
								elseif k == "requirements" then
									is_default_value = #result_value == 0
								elseif k == "is_build_cache" then
									is_default_value = true
								elseif k == "skin" then
									is_default_value = v == "default"
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
			--need correctly impl
			--[[
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
							local def = LOCATION_DEF.BY_ID.EDITOR
							def.path = location_path
							timer.delay(0, false, function ()
								self.world.game_world:change_location(LOCATION_DEF.BY_ID.EDITOR.id)
							end)
						end
					end
				end
			end--]]

			imgui.end_menu()
		end

		imgui.end_menu_bar()
	end
	--endregion

	if (imgui.tree_node("location" .. "##location_root")) then
		---@diagnostic disable-next-line: cast-local-type
		changed, x, y, z = imgui.input_float3("Spawn Position##LocationSpawnPosition", data.spawn_position.x, data.spawn_position.y, data.spawn_position.z)
		if changed then
			---@diagnostic disable-next-line: param-type-mismatch
			self:execute_command(ChangeSpawnPointCommand.new(self, vmath.vector3(x, y, z)))
		end

		if imgui.button("RESPAWN", 80, 20) then
			self.world.game_world:teleport(self.world.game_world.level_creator.player.player_go, data.spawn_position)
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

function System:draw_history_ui()
	local window_title = "HISTORY"

	imgui.begin_window(window_title, false)
	for i = #self.history, 1, -1 do
		local command = self.history[i]
		imgui.text(command:to_string())
	end

	imgui.end_window()
end

function System:trigger_need_update()
	self.world.game_world.level_creator.location_data:trigger_location_changed()
end

function System:get_location_data()
	return self.world and self.world.game_world and self.world.game_world.level_creator and self.world.game_world.level_creator.location_data
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
end

function System:on_remove_from_world()
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
end

function System:clear_highlight_from_entity(entity)
	if not entity then return end
	if entity.object_go then
		for i = 1, #entity.object_go.models do
			local model_go = entity.object_go.models[i]
			go.set(model_go.model, HASHES.TINT, model_go.tint)
		end
	end
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
	if self.gizmo.mode == imgui_gizmo.MODE_LOCAL then
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
		if self.gizmo.operation == imgui_gizmo.OPERATION_ROTATE then
			entry.rotation = vmath.quat(new_rotation)
		elseif self.gizmo.operation == imgui_gizmo.OPERATION_SCALE then
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

function System:draw_object_ui()
	local changed, value = false, nil
	local location_data = self.world.game_world.level_creator.location_data
	local selected_object = self:get_primary_selected_object()

	if selected_object then
		local object_cfg = selected_object
		local def = DEF_OBJECTS.BY_ID[object_cfg.type]
		local uniform_scale = (def.scale_type or ENUMS.SCALE_TYPE.UNIFORM) == ENUMS.SCALE_TYPE.UNIFORM
		local selection_signature = self:get_selection_signature()
		local selection_count = #self.selected_objects
		local parent_matrix = object_cfg.parent and location_data:get_world_transform(object_cfg.parent) or MATRIX_IDENTITY
		local base_matrix
		if selection_count > 1 then
			if self.gizmo.id ~= selection_signature or not imgui_gizmo.is_using_any() then
				self.gizmo.id = selection_signature
				self.gizmo_matrix = self:calculate_group_matrix()
			end
			base_matrix = self.gizmo_matrix
		else
			if self.gizmo.id ~= selection_signature or not imgui_gizmo.is_using_any() then
				self.gizmo.id = selection_signature
				self.gizmo_matrix = vmath.matrix4(location_data:get_world_transform(object_cfg.id))
			end
			base_matrix = self.gizmo_matrix

			--strange error with translate if rotation 180
			if self.gizmo.operation ~= imgui_gizmo.OPERATION_TRANSLATE then
				base_matrix = vmath.matrix4(location_data:get_world_transform(object_cfg.id))
			end
		end

		if imgui_gizmo and RENDER then
			imgui_gizmo.set_rect(0, 0, RENDER.screen_size.w, RENDER.screen_size.h)
			imgui_gizmo.set_drawlist_foreground()
		end

		local delta_matrix
		local gizmo_operation = self.gizmo.operation
		if gizmo_operation == imgui_gizmo.OPERATION_SCALE and uniform_scale then
			gizmo_operation = imgui_gizmo.OPERATION_SCALEU
		end
		changed, delta_matrix = imgui_gizmo.manipulate(RENDER.view, RENDER.proj, gizmo_operation, self.gizmo.mode, base_matrix)
		if changed then
			local target_matrix = delta_matrix * base_matrix
			self.gizmo_matrix = target_matrix
			local new_position = vmath.vector3()
			local new_rotation = vmath.quat()
			local new_scale = vmath.vector3()
			---@diagnostic disable-next-line: param-type-mismatch
			xmath.matrix_get_transforms(delta_matrix, new_position, new_scale, new_rotation)
			new_position.x = new_position.x * (1 / new_scale.x)
			new_position.y = new_position.y * (1 / new_scale.y)
			new_position.z = new_position.z * (1 / new_scale.z)
			---@diagnostic disable-next-line: param-type-mismatch
			xmath.matrix_from_transforms(delta_matrix, new_position, new_scale, new_rotation)

			if selection_count > 1 then
				self:apply_multi_gizmo(delta_matrix, base_matrix)
			else
				local object_local = vmath.inv(parent_matrix) * target_matrix
				xmath.matrix_get_transforms(object_local, new_position, new_scale, new_rotation)
				if self.gizmo.operation == imgui_gizmo.OPERATION_TRANSLATE then
					self:execute_command(ChangePositionObjectCommand.new(self, selected_object, new_position))
				elseif self.gizmo.operation == imgui_gizmo.OPERATION_ROTATE then
					self:execute_command(ChangeRotationObjectCommand.new(self, selected_object, new_rotation))
				elseif self.gizmo.operation == imgui_gizmo.OPERATION_SCALE then
					self:execute_command(ChangeScaleObjectCommand.new(self, selected_object, vmath.mul_per_elem(object_cfg.scale, new_scale)))
				end
				self:object_changed(object_cfg.id)
			end
		end
	end

	imgui.begin_window("Object", false, imgui.WINDOWFLAGS_MENUBAR)


	if imgui.button("Translate", 80, 40) then
		self.gizmo.operation = imgui_gizmo.OPERATION_TRANSLATE
	end
	imgui.same_line()
	if imgui.button("Rotate", 80, 40) then
		self.gizmo.operation = imgui_gizmo.OPERATION_ROTATE
	end
	imgui.same_line()
	if imgui.button("Scale", 80, 40) then
		self.gizmo.operation = imgui_gizmo.OPERATION_SCALE
	end
	imgui.same_line()
	changed, value = imgui.checkbox("World", self.gizmo.mode == imgui_gizmo.MODE_WORLD)
	if changed then
		self.gizmo.mode = value and imgui_gizmo.MODE_WORLD or imgui_gizmo.MODE_LOCAL
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
	local def = DEF_OBJECTS.BY_ID[object_cfg.type]
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

	---@diagnostic disable-next-line: cast-local-type
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


	if imgui.begin_combo("Filter##object_type_filter", self.object_type_filter) then
		for i = 1, #DEF_OBJECTS.TYPES_ORDER do
			local filter = DEF_OBJECTS.TYPES_ORDER[i]
			local is_selected = self.object_type_filter == filter
			if imgui.selectable(filter, is_selected) and not is_selected then
				self:execute_command(ChangeObjectTypeFilterCommand.new(self, filter))
			end
			if is_selected then
				imgui.set_item_default_focus()
			end
		end
		imgui.end_combo()
	end

	if imgui.begin_combo("type##items_id", object_cfg.type) then
		local current_type = self.object_type_filter
		local type_list = DEF_OBJECTS.TYPES_LIST[current_type]
		for i = 1, #type_list do
			if imgui.selectable(type_list[i], type_list[i] == object_cfg.type) then
				if object_cfg.type ~= type_list[i] then
					self:execute_command(ChangeTypeObjectCommand.new(self, selected_object, type_list[i]))
				end
			end
			if type_list[i] == object_cfg.type then
				imgui.set_item_default_focus()
			end
		end
		imgui.end_combo()
	end

	if #def.skins == 1 and def.skins[1].id == "default" then
		--pass
	else
		if imgui.begin_combo("Skin##ObjectSkin", object_cfg.skin) then
			for i = 1, #def.skins do
				local skin = def.skins[i]
				local is_selected = skin.id == object_cfg.skin
				if imgui.selectable(skin.id, is_selected) and not is_selected then
					self:execute_command(ChangeSkinObjectCommand.new(self, selected_object, skin.id))
				end
				if is_selected then
					imgui.set_item_default_focus()
				end
			end
			imgui.end_combo()
		end
	end

	---@diagnostic disable-next-line: cast-local-type
	changed, x, y, z = imgui.input_float3("Position##ObjectPosition", object_cfg.position.x, object_cfg.position.y, object_cfg.position.z)
	if changed then
		---@diagnostic disable-next-line: param-type-mismatch
		self:execute_command(ChangePositionObjectCommand.new(self, selected_object, vmath.vector3(x, y, z)))
	end

	xmath.quat_to_euler(TEMP_V, object_cfg.rotation)
	---@diagnostic disable-next-line: cast-local-type
	changed, x, y, z = imgui.input_float3("Rotation##ObjectRotation", TEMP_V.x, TEMP_V.y, TEMP_V.z)
	if changed then
		---@diagnostic disable-next-line: param-type-mismatch
		xmath.vector3_set_components(TEMP_V, x, y, z)
		local quat = vmath.quat_rotation_x(0)
		xmath.euler_to_quat(quat, TEMP_V)
		self:execute_command(ChangeRotationObjectCommand.new(self, selected_object, quat))
	end
	local uniform_scale = (def.scale_type or ENUMS.SCALE_TYPE.UNIFORM) == ENUMS.SCALE_TYPE.UNIFORM
	if uniform_scale then
		---@diagnostic disable-next-line: cast-local-type
		changed, x = imgui.input_float("Scale##ObjectScaleUniform", object_cfg.scale.x)
		if changed and x > 0 then
			---@diagnostic disable-next-line: param-type-mismatch
			self:execute_command(ChangeScaleObjectCommand.new(self, selected_object, vmath.vector3(x, x, x)))
		end
	else
		---@diagnostic disable-next-line: cast-local-type
		changed, x, y, z = imgui.input_float3("Scale##ObjectScale", object_cfg.scale.x, object_cfg.scale.y, object_cfg.scale.z)
		if changed and x > 0 and y > 0 and z > 0 then
			---@diagnostic disable-next-line: param-type-mismatch
			self:execute_command(ChangeScaleObjectCommand.new(self, selected_object, vmath.vector3(x, y, z)))
		end
	end

	---@diagnostic disable-next-line: cast-local-type
	changed, x, y, z, w = imgui.input_float4("Tint##ObjectTint", object_cfg.tint.x, object_cfg.tint.y, object_cfg.tint.z, object_cfg.tint.w)
	if changed then
		local v4 = vmath.vector4(LUME.clamp(x, 0, 1), LUME.clamp(y, 0, 1), LUME.clamp(z, 0, 1), LUME.clamp(w, 0, 1))
		self:execute_command(ChangeTintObjectCommand.new(self, selected_object, v4))
	end

	imgui.end_window()
end

function System:object_changed(id)
	local location_data = self.world.game_world.level_creator.location_data
	local object = location_data:find_by_id(id)
	if not object then return end

	location_data:transform_changed(id)
	local entity = self:find_entity_by_id(id)
	if entity then
		self.world:remove_entity(entity)
	else
		print("no entity with id:" .. id)
	end
	--entity is not added to world. So don't need to create it again
	---@class Entity
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
	if IMGUI:is_imgui_handled_input() then
		self.touch_action = nil
	end
	if not INPUT.TOUCH and self.touch_action then
		local action = self.touch_action
		self.touch_action = nil
		local time = socket.gettime() - INPUT.get_key_data(HASHES.INPUT.TOUCH).pressed_time
		if time < 0.15 then
			CAMERAS.current_camera:screen_to_world_ray_to_vector3(action.screen_x, action.screen_y, RAYCAST_FROM, RAYCAST_TO)
			---@diagnostic disable-next-line: unused-local
			local hit, hx, hy, hz, _, _, _, id = physics_utils.physics_raycast_single(RAYCAST_FROM, RAYCAST_TO, self.raycast_mask)
			if hit and id then
				local e = self.world.game_world.ecs.entities.collision_to_object[id]
				if e then
					e = e.object_config_entity
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
	if not LevelEditor3dFeature.storage:is_editor_visible() then return end
	if not self.world then return end
	if not imgui then return end
	if INPUT.get_key_data(HASHES.INPUT.T).pressed then
		self.gizmo.operation = imgui_gizmo.OPERATION_TRANSLATE
	elseif INPUT.get_key_data(HASHES.INPUT.Y).pressed then
		self.gizmo.operation = imgui_gizmo.OPERATION_ROTATE
	elseif INPUT.get_key_data(HASHES.INPUT.U).pressed then
		self.gizmo.operation = imgui_gizmo.OPERATION_SCALE
	elseif INPUT.get_key_data(HASHES.INPUT.I).just_pressed then
		self.gizmo.mode = self.gizmo.mode == imgui_gizmo.MODE_LOCAL and imgui_gizmo.MODE_WORLD or imgui_gizmo.MODE_LOCAL
	end
	self:select_object_raycast()
	--self:draw_history_ui()
	self:draw_location_ui()
	self:draw_object_ui()
	self:update_selection_visuals()

	if INPUT.get_key_data(HASHES.INPUT.LEFT_CTRL).pressed and INPUT.get_key_data(HASHES.INPUT.Z).just_pressed then
		self:undo()
	end
end

return System
