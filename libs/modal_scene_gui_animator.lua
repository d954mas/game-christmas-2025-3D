local CLASS = require "libs.class"
local ACTIONS = require "libs.actions.actions"
local TWEEN = require "libs.tween"
local CONSTANTS = require "libs.constants"

local SCALE_START = vmath.vector3(0.01)

local Animator = CLASS.class("ModalSceneGuiAnimator")

function Animator.new() return CLASS.new_instance(Animator) end

function Animator:initialize()
    self.vh = {
        root = gui.get_node("root"),
        fader = gui.get_node("fader"),
    }

    self.animation_action = ACTIONS.Sequence.new(false)
    self.animation_action.drop_empty = false
    self.scale_root = gui.get_scale(self.vh.root)

    self.fader_color = gui.get_color(self.vh.fader)

    self.fader_hide_color = vmath.vector4(self.fader_color)
    self.fader_hide_color.w = 0

    gui.set_color(self.vh.fader, self.fader_hide_color)
end

function Animator:show()
    while (not self.animation_action:is_empty()) do self.animation_action:update(1) end


    gui.set_color(self.vh.fader, self.fader_hide_color)

    gui.set_color(self.vh.root, CONSTANTS.COLORS.EMPTY)
    gui.set_scale(self.vh.root, SCALE_START)

    local show_parallel = ACTIONS.Parallel.new(false)

    show_parallel:add_action(ACTIONS.TweenGui.new_noctx({
        object = self.vh.fader, property = "color",
        to = self.fader_color, time = 0.1, easing = TWEEN.easing.outCubic
    }))

    show_parallel:add_action(ACTIONS.TweenGui.new_noctx({
        object = self.vh.root, property = "color",
        to = CONSTANTS.COLORS.WHITE, time = 0.2, easing = TWEEN.easing.outCubic, delay = 0
    }))
    show_parallel:add_action(ACTIONS.TweenGui.new_noctx({
        object = self.vh.root, property = "scale",
        from = SCALE_START, to = self.scale_root, time = 0.5, easing = TWEEN.easing.outBack, delay = 0.05
    }))

    self.animation_action:add_action(show_parallel)
end

function Animator:update(dt)
    self.animation_action:update(dt)
end

function Animator:hide()
    while (not self.animation_action:is_empty()) do self.animation_action:update(1) end
    local show_parallel = ACTIONS.Parallel.new(false)

    show_parallel:add_action(ACTIONS.TweenGui.new_noctx {
        object = self.vh.fader, property = "color",
        to = self.fader_hide_color, time = 0.15, easing = TWEEN.easing.outCubic, delay = 0.05
    })

    show_parallel:add_action(ACTIONS.TweenGui.new_noctx {
        object = self.vh.root, property = "color",
        to = CONSTANTS.COLORS.EMPTY, time = 0.2, easing = TWEEN.easing.outQuad, delay = 0
    })
    show_parallel:add_action(ACTIONS.TweenGui.new_noctx {
        object = self.vh.root, property = "scale",
        from = self.scale_root, to = SCALE_START, time = 0.25, easing = TWEEN.easing.outQuad, delay = 0
    })

    self.animation_action:add_action(show_parallel)
end

function Animator:is_working()
    return not self.animation_action:is_empty()
end

return Animator
