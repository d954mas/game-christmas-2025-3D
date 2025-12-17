local CLASS = require "libs.class"

local Sdk = CLASS.class("MockSdk")

---@param sdks Sdks
function Sdk.new(sdks) return CLASS.new_instance(Sdk, sdks) end

---@param sdks Sdks
function Sdk:initialize(sdks)
    self.sdks = assert(sdks)
    self.show_ads = true
end

function Sdk:init()
end

function Sdk:ads_rewarded(cb, _)
    if not self.show_ads then
        if android_toast then
            android_toast.toast("Rewarded AD failed to show", 0)
        end
    end
    cb(self.show_ads)
end

function Sdk:ads_commercial(cb)
    cb(self.show_ads)
end

return Sdk
