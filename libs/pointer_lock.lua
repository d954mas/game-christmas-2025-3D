local CONSTANTS = require "libs.constants"

local M = {}

M.need_locked = false
M.locked = false


function M.unlock_cursor()
	if CONSTANTS.IS_MOBILE_DEVICE then return end
	M.need_locked = false
	window.set_mouse_lock(false)
end

function M.lock_cursor()
	if CONSTANTS.IS_MOBILE_DEVICE then return end
	M.need_locked = true
	--set_mouse_lock don't work in browser
	if not html5 then
		window.set_mouse_lock(true)
		M.locked = true
	end
end

function M.init()
	if (html5) then
		html5.set_interaction_listener(function ()
			if (M.need_locked and not M.locked) then
				window.set_mouse_lock(true)
			end
		end)
	end
end

function M.update()
	if CONSTANTS.IS_MOBILE_DEVICE then
		M.locked = false
	else
		M.locked = window.get_mouse_lock()
		if M.locked then
			M.need_locked = false
		end
	end
end

return M
