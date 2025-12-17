local CLASS = require "libs.class"

local TABLE_INSERT = table.insert
local TABLE_REMOVE = table.remove

---@class Stack
local Stack = CLASS.class("Stack")

function Stack.new()
	return CLASS.new_instance(Stack)
end

function Stack:initialize()
	self.stack = {}
end

---Pushes a value at the head of the heap
---@param value Scene
function Stack:push(value)
	TABLE_INSERT(self.stack, value)
end

---Remove and return the value at the head of the heap
---@return Scene
function Stack:pop() return TABLE_REMOVE(self.stack) end

---Looks at the object of this stack without removing it from the stack.
---@return Scene
function Stack:peek(value)
	return self.stack[#self.stack - (value or 0)]
end

---@return number|nil count of pop values to get to the scene or nil if not found
function Stack:find_scene(scene)
	for id = #self.stack, 1, -1 do
		if self.stack[id] == scene then
			return #self.stack - id + 1
		end
	end
end

return Stack
