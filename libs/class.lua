---@diagnostic disable: inject-field
local M = {}

---@class ClassData
---@field name string
---@field parent ClassData

---@class BaseClass
---@field __class  ClassData


---@generic T
---@param class T
---@return T
function M.new_instance(class, ...)
	--first time create instance. Prepare instance table
	if not class.instance_factory then
		--do not copy name and parent
		local class_name, class_parent, class_new = class.name, class.parent, class.new
		class.name, class.parent, class.new = nil, nil, nil

		local factory_str = "return function(class) return { __class=class,"
		for k, _ in pairs(class) do
			factory_str = factory_str .. k .. " =class." .. k .. ", "
		end
		factory_str = factory_str .. "} end"
		class.name, class.parent, class.new = class_name, class_parent, class_new
		class.instance_factory = loadstring(factory_str)()
	end
	local instance = class.instance_factory(class)
	if instance.initialize then instance:initialize(...) end
	return instance
end

---all methods of class should be defined before subclassing
function M.class(name, parent)
	assert(type(name) == 'string')
	local class = {}
	--copy values from parent classes
	if parent then
		for k, v in pairs(parent) do class[k] = v end
		class.instance_factory = nil
		class.new = nil
	end
	class.name = name
	class.parent = parent
	return class
end

--[[
function M.is_instance_of(instance, class)
	assert(class)
	local parent = instance.__class
	while parent do
		if parent == class then return true end
		parent = parent.parent
	end
	return false
end
--]]
function M.is_instance_of_by_name(instance, name)
	assert(name)
	local parent = instance.__class
	while parent do
		if parent.name == name then return true end
		parent = parent.parent
	end
	return false
end

return M
