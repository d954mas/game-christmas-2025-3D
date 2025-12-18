local CLASS = require "libs.class"
local CHECKS = require "libs.checks"
local CONTEXTS = require "libs.contexts_manager"
local EVENTS = require "libs.events"
local INPUT = require "features.core.input.input"
local GuiResizer = require "features.core.gui_resizer"


local ConfigTypeDef = {
	context_name = "?string",
	input = "?boolean", --true by default
	scene = "?class:Scene",
	input_priority = "?number"
}

---@class BaseGuiScript
---@field on_storage_changed function()
---@field on_resize function(width : number, height : number)
---@field on_language_changed function()
local Script = CLASS.class("BaseGuiScript")

function Script:bind_vh() end

function Script:init_gui() end

function Script:init(config)
	CHECKS("?", ConfigTypeDef)
	self.config = config
	if (self.config.input == nil) then self.config.input = true end
	if (self.config.context_name) then CONTEXTS:register(self.config.context_name, self) end
	self.gui_resizer = GuiResizer.new()
	self.subscriptions = {}
	self:bind_vh()
	self:init_gui()

	if self.on_storage_changed then
		table.insert(self.subscriptions, EVENTS.STORAGE_CHANGED:subscribe(true, function ()
			self:on_storage_changed()
		end))
		self:on_storage_changed()
	end

	table.insert(self.subscriptions, EVENTS.WINDOW_RESIZED:subscribe(true, function ()
		self:on_resize()
	end))
	self:on_resize()

	if self.on_language_changed then
		table.insert(self.subscriptions, EVENTS.LANGUAGE_CHANGED:subscribe(true, function ()
			self:on_language_changed()
		end))
		self:on_language_changed()

		--fixed font changed by script
		timer.delay(0, false, function ()
			self:on_language_changed()
		end)
	end

	if (self.config.input) then INPUT.acquire(self, self.config.input_priority, self.config.scene) end
end

function Script:on_resize()
	self.gui_resizer:resize()
end

function Script:final()
	for i = 1, #self.subscriptions do self.subscriptions[i]() end
	if (self.config.context_name) then CONTEXTS:unregister(self.config.context_name) end
	if (self.config.input) then INPUT.release(self) end
end

return Script
