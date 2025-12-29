local CLASS = require "libs.class"
local CONSTANTS = require "libs.constants"

local StoragePart = require "features.core.storage.storage_part"

---@class IlluminationStoragePart:StoragePart
local Storage = CLASS.class("IlluminationStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.illumination = self.storage.data.illumination
    if not self.illumination then
        self.illumination = {
            debug_lights = false,
            debug_shadow = false,
            draw_shadows = true --not CONSTANTS.IS_MOBILE_DEVICE
        }
        self.storage.data.illumination = self.illumination
    end
end

function Storage:is_debug_lights()
	return self.illumination.debug_lights
end

function Storage:set_debug_lights(debug)
	self.illumination.debug_lights = debug
    self:save()
end

function Storage:is_debug_shadow()
	return self.illumination.debug_shadow
end

function Storage:set_debug_shadow(debug)
	self.illumination.debug_shadow = debug
    self:save()
end

function Storage:draw_shadows_get()
	return self.illumination.draw_shadows
end

function Storage:draw_shadows_set(draw)
	self.illumination.draw_shadows = draw
    self:save_and_changed()
end


return Storage
