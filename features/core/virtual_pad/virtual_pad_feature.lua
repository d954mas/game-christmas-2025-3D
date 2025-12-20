local CONSTANTS = require "libs.constants"
local HASHES = require "libs.hashes"
local CONTEXTS = require "libs.contexts_manager"
local TWEEN = require "libs.tween"
local VirtualPad = require "features.core.virtual_pad.virtual_pad"

---@class VirtualPadFeature:Feature
local VirtualPadFeature = {}

function VirtualPadFeature:init()

end

function VirtualPadFeature:on_game_gui_init()
    self.virtual_pad = VirtualPad.new("virtual_pad")
    --config 2d game
    self.virtual_pad.fixed_position = false
    self.virtual_pad.always_visible = false
    self.virtual_pad.always_visible_before_first_input = true

    --for pc initial position for virtual_pad is center
    if not CONSTANTS.IS_MOBILE_DEVICE then
        self.virtual_pad.position_initial.x = 960 / 2 - 100
        self.virtual_pad.position_initial.y = 0
        gui.set_position(self.virtual_pad.vh.anchor, self.virtual_pad.position_initial)
    end
end

function VirtualPadFeature:on_game_gui_update(_, dt)
    self.virtual_pad:update(dt)
end

function VirtualPadFeature:on_game_gui_on_input(_, action_id, _)
    if action_id == HASHES.INPUT.TOUCH or action_id == HASHES.INPUT.TOUCH_MULTI then
        if self.virtual_pad:on_input() then return true end
    end
end

function VirtualPadFeature:reset()
    if self.virtual_pad then
        self.virtual_pad:reset()
    end
end

function VirtualPadFeature:on_resize()
    if CONTEXTS:exist(CONTEXTS.NAMES.GAME_GUI) then
        local ctx = CONTEXTS:set_context_top_by_name(CONTEXTS.NAMES.GAME_GUI)
        self.virtual_pad:on_resize()
        ctx:remove()
    end
end

function VirtualPadFeature:get_data()
    if self.virtual_pad and CONTEXTS:exist(CONTEXTS.NAMES.GAME_GUI) then
        local ctx = CONTEXTS:set_context_top_by_name(CONTEXTS.NAMES.GAME_GUI)
        if (self.virtual_pad:visible_is()) then
			if (not self.virtual_pad:is_safe()) then
                local x, y = self.virtual_pad:get_data()
                local min = 0.2
				local a = math.max(math.abs(x), math.abs(y))
                local speed_limit =  min + (1 - min) * TWEEN.easing.outQuad(a, 0, 1, 1)
                ctx:remove()
                return x, y, speed_limit
			end
		end
        ctx:remove()
    end
end

return VirtualPadFeature
