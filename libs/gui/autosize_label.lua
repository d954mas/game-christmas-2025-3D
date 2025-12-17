local CLASS = require "libs.class"
local LOCALIZATION = require "libs.localization"

local TEMP_V = vmath.vector3()

---@class AutosizeLbl
local Lbl = CLASS.class("AutosizeLbl")

function Lbl.new(node)
	return CLASS.new_instance(Lbl, node)
end

function Lbl:initialize(node)
	self.node = type(node) == "string" and gui.get_node(node) or node
	self.scale = gui.get_scale(self.node)
	self.size = gui.get_size(self.node)
	self.font = gui.get_font(self.node)
	self.font_resource = gui.get_font_resource(self.font)
	self.metrics_config = {
		tracking = gui.get_tracking(self.node),
		line_break = gui.get_line_break(self.node),
		width = self.size.x
	}
	self.language = LOCALIZATION:locale_get()
end

---@diagnostic disable-next-line: unused-local
function Lbl:set_text(text, forced)
	local locale = LOCALIZATION:locale_get()
	local font_resource = gui.get_font_resource(self.font)
	if self.language ~= locale or self.text ~= text or forced or self.font_resource ~= font_resource then
		self.language = locale
		self.text = text
		self.font_resource = font_resource
		local metrics = resource.get_text_metrics(font_resource, text, self.metrics_config)
		if (metrics.width > self.size.x) then
			xmath.mul(TEMP_V, self.scale, self.size.x / metrics.width)
			gui.set_scale(self.node, TEMP_V)
		else
			gui.set_scale(self.node, self.scale)
		end
		gui.set_text(self.node, text)
	end
end

function Lbl:set_enabled(enabled)
	gui.set_enabled(self.node, enabled)
end

return Lbl
