local CLASS = require "libs.class"
local LOCALIZATION = require "libs.localization"

local TEMP_V = vmath.vector3()

---@class AutosizeLblComponent
local Lbl = CLASS.class("AutosizeLblComponent")

function Lbl.new(url)
    return CLASS.new_instance(Lbl, url)
end

function Lbl:initialize(url)
    self.url = url
    self.scale = go.get_scale(self.url)
    self.size = go.get(self.url, "size")
    self.font_resource = go.get(self.url, "font")
    self.font_all = false
    self.metrics_config = {
        tracking = go.get(self.url, "tracking"),
        line_break = go.get(self.url, "line_break"),
        width = self.size.x
    }
    self.language = LOCALIZATION:locale_get()
end

function Lbl:check_font()
    if not self.font_all and LOCALIZATION.font_all then
        go.set(self.url, "font", LOCALIZATION.font_all)
        self.font_all = true
    end
end

---@diagnostic disable-next-line: unused-local
function Lbl:set_text(text, forced)
    local locale = LOCALIZATION:locale_get()
    ---@type hash
    ---@diagnostic disable-next-line: assign-type-mismatch
    local font_resource = go.get(self.url, "font")
    if self.language ~= locale or self.text ~= text or forced or self.font_resource ~= font_resource then
        self.language = locale
        self.text = text
        self.font_resource = font_resource
        local metrics = resource.get_text_metrics(font_resource, text, self.metrics_config)
        if (metrics.width > self.size.x) then
            xmath.mul(TEMP_V, self.scale, self.size.x / metrics.width)
            go.set_scale( TEMP_V, self.url)
        else
            go.set_scale(self.scale, self.url)
        end
        label.set_text(self.url, text)
    end
end

return Lbl
