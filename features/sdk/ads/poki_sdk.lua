local CLASS = require "libs.class"

local Sdk = CLASS.class("PokiSdk")

---@param sdks Sdks
function Sdk.new(sdks) return CLASS.new_instance(Sdk, sdks) end

---@param sdks Sdks
function Sdk:initialize(sdks)
    self.sdks = assert(sdks)
end

function Sdk:init()
    html5.run("navigator.sendBeacon('https://leveldata.poki.io/loaded', 'ID HERE')")
end

function Sdk:ads_rewarded(cb, _)
    poki_sdk.rewarded_break(function (_, status)
        if status == poki_sdk.REWARDED_BREAK_ERROR then
            cb(false)
        elseif status == poki_sdk.REWARDED_BREAK_START then

        elseif status == poki_sdk.REWARDED_BREAK_SUCCESS then
            cb(true)
        end
    end)
end

function Sdk:ads_commercial(cb)
    if self.sdks.data.gameplay_start_send then
        self.sdks:gameplay_stop()
        poki_sdk.commercial_break(function (_)
            cb(true)
        end)
    else
        cb(true)
    end
end

function Sdk:gameplay_start()
    poki_sdk.gameplay_start()
end

function Sdk:gameplay_stop()
    poki_sdk.gameplay_stop()
end

return Sdk
