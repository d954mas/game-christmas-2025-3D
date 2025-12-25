local ANIM = require "features.core.mesh_char.mesh_char_animations_def"
local ENUMS = require "game.enums"

local M = {}

M.BY_ID = {}

M.BY_ID.UNKNOWN = {
	id = "UNKNOWN",
	unlock = { type = ENUMS.SKIN_UNLOCK_TYPE.PLAYER_LEVEL, value = -1 },
	mesh = "char_base",
	factory = msg.url("game_scene:/root#factory_char_unknown"),
	factory_tpose = msg.url("game_scene:/root#factory_char_unknown_skin"),
	scale = vmath.vector3(1),
	icon = hash("char_unknown"),
	animations = {
		IDLE = { ANIM.BY_ID.LOOK_AROUND },
		RUN = { ANIM.BY_ID.RUN_BASE },
	}
}

M.BY_ID.BASE = {
	id = "BASE",
	unlock = { type = ENUMS.SKIN_UNLOCK_TYPE.PLAYER_LEVEL, value = -1 },
	mesh = "char_base",
	factory = msg.url("game_scene:/root#factory_char_base"),
	factory_tpose = msg.url("game_scene:/root#factory_char_base_skin"),
	scale = vmath.vector3(1),
	icon = hash("char_boxer"),
	animations = {
		IDLE = { ANIM.BY_ID.LOOK_AROUND },
		RUN = { ANIM.BY_ID.RUN_BASE },
	}
}



M.PLAYER_LIST_SKINS = {
	--FREE
	M.BY_ID.BASE,
}

M.LIVEUPDATE = {
	--M.BY_ID.BOXER,
	--M.BY_ID.BOXER_GIRL,
}

for _, v in ipairs(M.LIVEUPDATE) do
	v.liveupdate = true
end

for k, v in pairs(M.BY_ID) do
	v.id = k
	local lower_case = string.lower(v.id)
	v.mesh = v.mesh or "char_base"
	v.factory = v.factory or msg.url("game_scene:/root#char_" .. lower_case)
	v.scale = v.scale or vmath.vector3(1)
	v.icon = v.icon or hash("char_" .. lower_case)
	v.animations = v.animations or {
		IDLE = { ANIM.BY_ID.LOOK_AROUND },
		RUN = { ANIM.BY_ID.RUN_BASE },
	}
	assert(v.unlock)
end

return M
