local CLASS = require "libs.class"
local ECS = require 'libs.ecs'
local ENUMS = require 'game.enums'
local GAME_MESH_READER = require "features.core.mesh_char.game_mesh_reader"
local LIVEUPDATE = require "features.core.liveupdate.liveupdate"
local LUME = require "libs.lume"
local MeshAnimator = require "features.core.mesh_char.mesh_animator"
local SKINS_3D_DEF = require "features.meta.skins.skins3d_def"
local HATS_3D_DEF = require "features.meta.skins.hats3d_def"
local ANIMATIONS_DEF = require "features.core.mesh_char.mesh_char_animations_def"
local PlayerItemsInHandFeature = require "features.gameplay.player.player_items_in_hand_feature"

local TEMP_V = vmath.vector3()
local TEMP_Q = vmath.quat_rotation_z(0)

local PLAYER_INITIAL_SKIN_POS = vmath.vector3(0, -0.1, 0)

local HASH_MESH = hash("mesh")

local GO_SET_ROTATION = go.set_rotation
local GO_SET_POSITION = go.set_position


local PARTS = {
    ROOT = hash("/root"),
    MESH = hash("/mesh"),
    MODEL = hash("/model"),
    ORIGIN = hash("/origin"),
}

local V_LOOK_DIR = vmath.vector3(0, 0, -1)

local Q_ROTATION = vmath.quat_rotation_z(0)

local BASE_BLEND_LOOP = { blend_duration = 0.1, loops = -1 }
local LONG_BLEND_LOOP = { blend_duration = 0.5, loops = -1 }


---@class DrawPlayer3dSystem:EcsSystem
local System = CLASS.class("DrawPlayer3dSystem", ECS.System)
System.filter = ECS.filter("player")

function System.new() return CLASS.new_instance(System) end

---@param e Entity
function System:draw_hat(e)
    local hat_id = SKINS_3D_DEF.BY_ID[e.skin].hat
    if hat_id and e.player_go.model.root then
        local hat_def = assert(HATS_3D_DEF.BY_ID[hat_id])
        if e.player_go.config.hat ~= hat_def.id then
            e.player_go.config.hat = hat_def.id
            if (e.player_go.hat.root) then
                go.delete(e.player_go.hat.root, true)
                e.player_go.hat.root = nil
            end

            if hat_def then
                local urls = collectionfactory.create(hat_def.factory, nil, nil, nil, hat_def.scale)
                e.player_go.hat.root = msg.url(urls[PARTS.ROOT])
                e.player_go.hat.model = msg.url(urls[PARTS.MODEL])
                if hat_def.color then
                    local model = LUME.url_component_from_url(e.player_go.hat.model, "model")
                    go.set(model, "tint", hat_def.color)
                end
                go.set_parent(e.player_go.hat.root, e.player_go.model.mesh_origin, false)
            end
        end
    end

    if e.player_go.hat.root then
        TEMP_V.x, TEMP_V.y, TEMP_V.z, TEMP_Q.x, TEMP_Q.y, TEMP_Q.z, TEMP_Q.w = e.player_go.model.mesh:get_bone_transform(
            3)
        GO_SET_POSITION(TEMP_V, e.player_go.hat.root)
        GO_SET_ROTATION(TEMP_Q, e.player_go.hat.root)
    end
end

---@param e Entity
function System:get_animation(e)
    if (e.moving) then
        return ENUMS.ANIMATIONS.RUN
    end
    return ENUMS.ANIMATIONS.IDLE
end

function System:on_remove(e)
    if (e.player_go.model.root) then
        go.delete(e.player_go.model.root, true)
        e.player_go.model.root = nil
        e.player_go.model.mesh_root = nil

        if e.player_go.model.mesh then
            e.player_go.model.mesh:dispose()
            e.player_go.model.mesh = nil
        end
        e.player_go.model.mesh_animator = nil
        e.player_go.hat.root = nil
    end
    if e.player_go.hand_right_item.root then
        go.delete(e.player_go.hand_right_item.root, true)
        e.player_go.hand_right_item.root = nil
        e.player_go.hand_right_item.model = nil
    end
end

function System:update(dt)
    local entities = self.entities_list
    for i = 1, #entities do
        local e = entities[i]
        if (e.skin ~= e.player_go.config.skin) then
            local skin_def = assert(SKINS_3D_DEF.BY_ID[e.skin])
            if skin_def.liveupdate then
                if not LIVEUPDATE.is_ready() then
                    skin_def = SKINS_3D_DEF.BY_ID.UNKNOWN
                end
            end
            if e.player_go.config.skin ~= skin_def.id then
                e.player_go.config.skin = skin_def.id
                e.player_go.config.animation = nil
                --DELETE PREV SKIN
                self:on_remove(e)
            end
        end
        if (e.camera.first_view) and e.player_go.config.skin then
            e.player_go.config.skin = nil
            e.player_go.config.animation = nil
            e.player_go.config.hat = nil
            --DELETE PREV SKIN
            self:on_remove(e)
        end

        if (e.player_go.model.root == nil and (not e.camera.first_view)) then
            local skin_def = assert(SKINS_3D_DEF.BY_ID[e.player_go.config.skin])
            local urls = collectionfactory.create(skin_def.factory, PLAYER_INITIAL_SKIN_POS, nil, nil,
                skin_def.scale)
            local go_url = msg.url(urls[PARTS.ROOT])
            local mesh_url = msg.url(urls[PARTS.MESH])
            local mesh_origin = msg.url(urls[PARTS.ORIGIN])
            local mesh_comp_url = LUME.url_component_from_url(mesh_origin, HASH_MESH)
            --go.set_parent(go_url, e.player_go.root, false)
            e.player_go.model.root = go_url
            e.player_go.model.mesh_root = mesh_url
            e.player_go.model.mesh_origin = mesh_origin
            e.player_go.model.mesh = GAME_MESH_READER.get_mesh(skin_def.mesh)
            e.player_go.model.mesh:set_mesh_component(mesh_comp_url)
            e.player_go.model.mesh_animator = MeshAnimator.new(e.player_go.model.mesh)
            --for punch system
            e.player_go.model.mesh.tracks[2].bone_weights = ANIMATIONS_DEF.BONES_WEIGHS.ARM_ATTACK
            e.player_go.model.mesh.tracks[2].enabled = true
            go.set_parent(e.player_go.model.root, e.player_go.root, false)
        end

        if not e.player_go.model.root then
            return
        end

        local anim = self:get_animation(e)
        local skin_def = SKINS_3D_DEF.BY_ID[e.skin]
        local animations = skin_def.animations
        local prev = e.player_go.config.animation

        if (e.player_go.config.animation ~= anim) then
            e.player_go.config.animation = anim
            if (anim == ENUMS.ANIMATIONS.IDLE) then
                e.player_go.model.mesh_animator:play(animations.IDLE[1].id,
                    prev == ENUMS.ANIMATIONS.DIE and LONG_BLEND_LOOP or BASE_BLEND_LOOP)
            elseif (anim == ENUMS.ANIMATIONS.RUN) then
                e.player_go.model.mesh_animator:play(animations.RUN[1].id,
                    prev == ENUMS.ANIMATIONS.DIE and LONG_BLEND_LOOP or BASE_BLEND_LOOP)
            end
        end
        if e.punch then
            self:punch_animation(e, dt)
        end

        V_LOOK_DIR.x, V_LOOK_DIR.y, V_LOOK_DIR.z = e.look_dir.x, 0, e.look_dir.z
        xmath.normalize(V_LOOK_DIR, V_LOOK_DIR)

        e.player_go.config.look_dir_smooth_dump:update(e.player_go.config.look_dir, V_LOOK_DIR, dt)

        local angle = LUME.angle_vector(e.player_go.config.look_dir.x, -e.player_go.config.look_dir.z) - math.pi / 2
        xmath.quat_rotation_y(Q_ROTATION, angle)

        GO_SET_ROTATION(Q_ROTATION, e.player_go.model.root)
        e.player_go.model.mesh_animator:update(dt)
        self:draw_hat(e)
        self:draw_hand_right_item(e)
    end
end

---@param e Entity
function System:draw_hand_right_item(e)
    local desired_id = PlayerItemsInHandFeature.storage and PlayerItemsInHandFeature.storage:get_right_hand_item()
---@diagnostic disable-next-line: unused-local
    local item_def, item_type = self:get_hand_item_def(desired_id)
    local spawn_id = item_def and item_def.id or nil
    if e.player_go.config.hand_right_item ~= spawn_id then
        e.player_go.config.hand_right_item = spawn_id
        if e.player_go.hand_right_item.root then
            go.delete(e.player_go.hand_right_item.root, true)
            e.player_go.hand_right_item.root = nil
            e.player_go.hand_right_item.model = nil
        end
        if item_def and e.player_go.model.root then
            local urls = collectionfactory.create(assert(item_def.factory, "hand item factory missing:" .. tostring(spawn_id)), nil, nil, nil, item_def.scale)
            e.player_go.hand_right_item.root = msg.url(urls[PARTS.ROOT])
            e.player_go.hand_right_item.model = msg.url(urls[PARTS.MODEL])
            if item_def.color and e.player_go.hand_right_item.model then
                local model = LUME.url_component_from_url(e.player_go.hand_right_item.model, "model")
                go.set(model, "tint", item_def.color)
            end
            go.set_parent(e.player_go.hand_right_item.root, e.player_go.model.mesh_origin, false)
        end
    end

    if e.player_go.hand_right_item.root then
        TEMP_V.x, TEMP_V.y, TEMP_V.z, TEMP_Q.x, TEMP_Q.y, TEMP_Q.z, TEMP_Q.w = e.player_go.model.mesh:get_bone_transform(
            ANIMATIONS_DEF.BONES.Arm_Right_Lower_end)
        GO_SET_POSITION(TEMP_V, e.player_go.hand_right_item.root)
        GO_SET_ROTATION(TEMP_Q, e.player_go.hand_right_item.root)
    end
end

function System:punch_animation(e, dt)
    local cfg_punch = e.player_go.config.punch
    if cfg_punch.state ~= e.punch.state then
        cfg_punch.state = e.punch.state
        if (e.punch.state == ENUMS.PUNCH_STATE.PUNCH) then
            cfg_punch.blend = 0
        elseif (e.punch.state == ENUMS.PUNCH_STATE.COOLDOWN) then
            cfg_punch.blend = 0
        else
            e.player_go.model.mesh.tracks[1].weight = 1
            e.player_go.model.mesh.tracks[2].weight = 0
        end
    end

    if cfg_punch.state == ENUMS.PUNCH_STATE.PUNCH then
        cfg_punch.blend = math.min(cfg_punch.blend + dt, e.player_go.config.punch.blend_duration)
        local blend_a = cfg_punch.blend / cfg_punch.blend_duration

        if e.die then
            blend_a = 0
        end

        e.player_go.model.mesh.tracks[1].weight = 1 - blend_a
        e.player_go.model.mesh.tracks[2].weight = blend_a

        local attack = e.punch.attack.sequence[e.punch.combo]
        --loop animation for combo
        if e.punch.attack.animation then
            local animation_frames = e.player_go.model.mesh.mesh_data.animations[e.punch.attack.animation.animation.id]
            local _, animation_a = math.modf(e.punch.time_total / e.punch.attack.animation.time)
            local frame = math.floor(animation_frames.start + (animation_frames.length - 1) * animation_a)
            if e.punch.attack.animation.move_weight and e.player_go.config.animation == ENUMS.ANIMATIONS.RUN then
                e.player_go.model.mesh.tracks[1].weight = e.punch.attack.animation.move_weight
            end
            e.player_go.model.mesh:set_frame(2, frame)
        else
            --new animation for every punch
            local animation_frames = e.player_go.model.mesh.mesh_data.animations[attack.animation.id]
            local animation_a = e.punch.time / attack.attack_time
            local frame = math.floor(animation_frames.start + (animation_frames.length - 1) * animation_a)

            if e.punch.time_attack_combo_blend then
                local prev_attack = e.punch.attack_prev
                local prev_animation_frames = e.player_go.model.mesh.mesh_data.animations[prev_attack.animation.id]
                local prev_animation_a = e.punch.time_attack_prev / prev_attack.attack_time
                local prev_frame = math.floor(prev_animation_frames.start +
                    (prev_animation_frames.length - 1) * prev_animation_a)

                local blend = 1 - e.punch.time_attack_combo_blend / e.punch.time_attack_combo_blend_delay
                e.player_go.model.mesh:set_frame(2, frame, prev_frame, blend)
            else
                e.player_go.model.mesh:set_frame(2, frame)
            end
        end
    elseif cfg_punch.state == ENUMS.PUNCH_STATE.COOLDOWN then
        cfg_punch.blend = math.min(cfg_punch.blend + dt, e.player_go.config.punch.blend_duration)
        local blend_a = cfg_punch.blend / cfg_punch.blend_duration

        e.player_go.model.mesh.tracks[1].weight = blend_a
        e.player_go.model.mesh.tracks[2].weight = 1 - blend_a

        --when run first track should always visible
        if e.player_go.config.animation == ENUMS.ANIMATIONS.RUN then
            e.player_go.model.mesh.tracks[1].weight = e.player_go.model.mesh.tracks[1].weight + 1
        end
    end

    --pprint(go.get_position(e.player_go.root))
    --pprint(go.get_position(e.player_go.collision))
end

function System:get_hand_item_def(id)
    if not id then return nil end
    --[[local pickaxe = DEFS.PICKAXES.BY_ID[id]
	if pickaxe then return pickaxe, "pickaxe" end
	if DEFS.SWORDS and DEFS.SWORDS.BY_ID then
		local sword = DEFS.SWORDS.BY_ID[id]
		if sword then return sword, "sword" end
	end
	if DEFS.AXES and DEFS.AXES.BY_ID then
		local axe = DEFS.AXES.BY_ID[id]
		if axe then return axe, "axe" end
	end--]]
    return nil
end

return System
