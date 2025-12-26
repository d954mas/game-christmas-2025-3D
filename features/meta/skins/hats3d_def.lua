local ENUMS = require "game.enums"

local M = {}

M.BY_ID = {}


M.BY_ID.CROWN = {
	id = "CROWN",
	unlock = { type = ENUMS.SKIN_UNLOCK_TYPE.PLAYER_LEVEL, value = -1 },
	factory = msg.url("game_scene:/root#factory_hat_crown"),
	scale = vmath.vector3(1),
}

M.BY_ID.HEADPHONES = {
	id = "HEADPHONES",
	unlock = { type = ENUMS.SKIN_UNLOCK_TYPE.PLAYER_LEVEL, value = -1 },
	factory = msg.url("game_scene:/root#factory_hat_headphones"),
	scale = vmath.vector3(1),
}

M.BY_ID.ANONIM = {
	id = "ANONIM",
	unlock = { type = ENUMS.SKIN_UNLOCK_TYPE.MONEY, value = 50000 },
	factory = msg.url("game_scene:/root#factory_hat_anonim"),
	scale = vmath.vector3(1),
}


return M
