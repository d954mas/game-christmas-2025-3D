local EVENTS = require "libs.events"
local M = {
	safearea_status = nil,
	safearea = { top = 0, right = 0, bottom = 0, left = 0 },
	safearea_gui = { top = 0, right = 0, bottom = 0, left = 0 },
}
--[[
--PC TEST
safearea = {
	STATUS_NOT_READY_YET = 0,
	STATUS_OK = 1,
	STATUS_ERROR = 2,
}

safearea.get_insets = function ()
	local status = safearea.STATUS_OK
	local insets = { top = 0, right = 0, bottom = 0, left = 0 }
	if RENDER.screen_size.w > RENDER.screen_size.h then
		insets.right = 100
	else
		insets.top = 100
	end
	return insets, status
end
--]]
function M:on_resize()
	self.safearea_status = nil
	--add some delay or when change orientation received old values
	timer.delay(0.1, false, function ()
		self.safearea_status = nil
		self:refresh()
	end)
end

function M:refresh()
	if safearea and not self.safearea_status then
		self.safearea, self.safearea_status = safearea.get_insets()
		if self.safearea_status == safearea.STATUS_OK then
			local w, h = 960, 540

			self.safearea_gui.left = w * self.safearea.left / RENDER.screen_size.w
			self.safearea_gui.right = w * self.safearea.right / RENDER.screen_size.w
			self.safearea_gui.top = h * self.safearea.top / RENDER.screen_size.h
			self.safearea_gui.bottom = h * self.safearea.bottom / RENDER.screen_size.h

			--update insets in gui
			EVENTS.WINDOW_RESIZED:trigger()
		else
			self.safearea_status = nil
		end
	end
end

return M
