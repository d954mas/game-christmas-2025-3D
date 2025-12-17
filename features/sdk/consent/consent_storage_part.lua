local CLASS = require "libs.class"

local StoragePart = require "features.core.storage.storage_part"

---@class ConsentStoragePart:StoragePart
local Storage = CLASS.class("ConsentStoragePart", StoragePart)

function Storage.new(...) return CLASS.new_instance(Storage, ...) end

function Storage:initialize(...)
	StoragePart.initialize(self, ...)
	self.consent = self.storage.data.consent
    if not self.consent then
		self.consent = {
			show = false,
			consent = false,
		}
		self.storage.data.consent = self.consent
	end
    ---@class Storage
    local storage = self.storage
    storage.consent_storage = self
end

function Storage:is_show()
	return self.consent.show
end

function Storage:accept()
	self.consent.show = true
	self.consent.consent = true
	self:save()
end

function Storage:decline()
	self.consent.show = true
	self.consent.consent = false
	self:save()
end

function Storage:is_accepted()
	return self.consent.consent
end

return Storage
