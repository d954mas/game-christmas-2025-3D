local ANIMATIONS = require "features.core.mesh_char.mesh_char_animations_def"
local ENUMS = require "game.enums"
local ANIM = ANIMATIONS.BY_ID
local M = {}

M.BY_ID = {
	RESOURCE_OBJECT = { id = "RESOURCE_OBJECT",
		type = ENUMS.ATTACK_TYPE.COMBO,
		sequence = {
			{
				animation = ANIM.PICKAXE_ATTACK, input_time = 0.2, attack_at = 0.5, knockback_at = 0.9,
				attack_time = 62 / 60, hit_distance = 3, attack_at2 = 0.99,
				hit_angle_min = -80, hit_angle_max = 80, -- sound_at = 0.45,sound_f = "play_pickaxe_hit_sound",
				knockback = 10000, knockback_combo = 0, cooldown = 0.1, combo_blend = 0.1,
			},
			--[[ {
						  animation = ANIM.PUNCH, input_time = 0.2, attack_at = 0.3, attack_at2 = 0.8, knockback_at = 0.9,
						  attack_time = 0.4, hit_distance = 2, sound_at = 0.4,
						  hit_angle_min = -20, hit_angle_max = 20,
						  knockback = 10000, knockback_combo = 0, cooldown = 0.25, combo_blend = 0.1,
					  },--]]
		}
	},

}

for k, v in pairs(M.BY_ID) do
	v.id = k
end
return M
