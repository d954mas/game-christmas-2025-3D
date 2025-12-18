---@diagnostic disable: return-type-mismatch
local LOG = require "libs.log"
local TAG = "ContextManager"

local TABLE_REMOVE = table.remove
local TABLE_INSERT = table.insert

local CONTEXT_DATA_WRAPPER_POOL = {}
local CONTEXT_IDS_POOL = {}

---@class ContextManager
local CONTEXTS = {
	---@type ContextData[]
	context_map = {},
	---@type ContextStackData[]
	contexts_stack = {},
	id = 0
}

---@class ContextData
---@field context DefoldContext
---@field data table
---@field name string

---@class ContextStackData
---@field context DefoldContext context before set new
---@field id number



---@param self ContextDataWrapper
local function wrapper_remove(self)
	if not self.removed then CONTEXTS:remove_context_top(self.id) end
	self.removed = true
	TABLE_INSERT(CONTEXT_DATA_WRAPPER_POOL, self)
end

local function get_context_data_rapper(id, ctx, data)
	---@class ContextDataWrapper
	---@field remove function
	local wrapper = TABLE_REMOVE(CONTEXT_DATA_WRAPPER_POOL) or { remove = wrapper_remove }
	wrapper.id = assert(id)
	wrapper.ctx = assert(ctx)
	wrapper.data = data
	wrapper.removed = false
	return wrapper
end

local function get_context_id_table(id, context)
	local result = TABLE_REMOVE(CONTEXT_IDS_POOL) or {}
	result.id = id
	result.context = context
	return result
end

---@param name string
---@param data table
function CONTEXTS:register(name, data)
	assert(name)
	assert(not self.context_map[name], "context:" .. tostring(name) .. " already registered")
	self.context_map[name] = {
		context = lua_script_instance.Get(),
		data = data,
		name = name,
	}
	LOG.i("Context register:" .. name, TAG)
end

function CONTEXTS:unregister(name)
	assert(name)
	local ctx = self:get(name)
	assert(ctx.context == lua_script_instance.Get(), "can't unregister.Different context instances")
	for i = #self.contexts_stack, 1, -1 do
		if self.contexts_stack[i].context == ctx.context then
			TABLE_INSERT(CONTEXT_IDS_POOL, TABLE_REMOVE(self.contexts_stack, i))
		end
	end
	self.context_map[name] = nil
	LOG.i("Context unregister:" .. name, TAG)
end

function CONTEXTS:exist(name)
	return self.context_map[name] ~= nil
end

---@return ContextData
function CONTEXTS:get(name)
	return assert(self.context_map[name], "no context with name:" .. name)
end

---@return ContextDataWrapper
function CONTEXTS:set_context_top_by_name(name)
	assert(name)
	--LOG.i("set_context:" .. name,TAG,2)
	local ctx = self:get(name)
	return self:set_context_top_by_instance(ctx.context, ctx.data)
end

function CONTEXTS:set_context_top_by_instance(new, data)
	local current = lua_script_instance.Get()
	self.id = self.id + 1
	TABLE_INSERT(self.contexts_stack, get_context_id_table(self.id, current))
	if new ~= current then lua_script_instance.Set(new) end
	return get_context_data_rapper(self.id, new, data)
end

function CONTEXTS:remove_context_top(id)
	assert(id)
	local remove_idx = -1
	local remove_value = nil
	local stack_size = #self.contexts_stack
	for i = stack_size, 1, -1 do
		local value = self.contexts_stack[i]
		if value.id == id then
			remove_idx = i
			remove_value = value
			break
		end
	end

	for idx = remove_idx, stack_size do
		TABLE_INSERT(CONTEXT_IDS_POOL, self.contexts_stack[idx])
		self.contexts_stack[idx] = nil
	end

	if remove_value and remove_value.context ~= lua_script_instance.Get() then
		lua_script_instance.Set(remove_value.context)
	end
	if not remove_value then
		LOG.w("no context for id:" .. id, TAG)
	end
end

---PROJECT CONTEXTS
CONTEXTS.NAMES = {
	LOADER = "LOADER",
	LIVEUPDATE_COLLECTION = "LIVEUPDATE_COLLECTION",
	SETTINGS_GUI = "SETTINGS_GUI",
}

---@class ContextDataWrapperLoader:ContextDataWrapper
---@field data ScripLoader

---@return ContextDataWrapperLoader
function CONTEXTS:set_context_top_loader()
	return self:set_context_top_by_name(self.NAMES.LOADER)
end

return CONTEXTS
