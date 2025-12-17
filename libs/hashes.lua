local M = {}

M.INPUT = {
	ACQUIRE_FOCUS = hash("acquire_input_focus"),
	RELEASE_FOCUS = hash("release_input_focus"),
	BACK = hash("back"),
	TOUCH = hash("touch"),
	TOUCH_MULTI = hash("touch_multi"),
	RIGHT_CLICK = hash("mouse_button_right"),
	SCROLL_UP = hash("scroll_up"),
	SCROLL_DOWN = hash("scroll_down"),
	LEFT_CTRL = hash("key_lctr"),
	LEFT_SHIFT = hash("key_lshift"),
	SPACE = hash("key_space"),
	ENTER = hash("key_enter"),
	ARROW_LEFT = hash("key_left"),
	ARROW_RIGHT = hash("key_right"),
	ARROW_UP = hash("key_up"),
	ARROW_DOWN = hash("key_down"),

	NUMBER_0 = hash("key_0"),
	NUMBER_1 = hash("key_1"),
	NUMBER_2 = hash("key_2"),
	NUMBER_3 = hash("key_3"),
	NUMBER_4 = hash("key_4"),
	NUMBER_5 = hash("key_5"),
	NUMBER_6 = hash("key_6"),
	NUMBER_7 = hash("key_7"),
	NUMBER_8 = hash("key_8"),
	NUMBER_9 = hash("key_9"),

	BACKSPACE = hash("key_backspace"),

	W = hash("key_w"),
	E = hash("key_e"),
	S = hash("key_s"),
	A = hash("key_a"),
	D = hash("key_d"),
	F = hash("key_f"),
	Z = hash("key_z"),
	X = hash("key_x"),
	M = hash("key_m"),
	R = hash("key_r"),
	C = hash("key_c"),
	L = hash("key_l"),
	P = hash("key_p"),
	B = hash("key_b"),
	F5 = hash("key_f5"),
	F8 = hash("key_f8"),

	T = hash("key_t"),
	Y = hash("key_y"),
	U = hash("key_u"),
	I = hash("key_i"),
	ESCAPE = hash("key_esc"),
	EQUALS = hash("key_equals"),
}

M.PHYSICS = {
		CONTACT_POINT_RESPONSE = hash("contact_point_response"),
		COLLISION_RESPONSE = hash("collision_response"),
		TRIGGER_RESPONSE = hash("trigger_response"),
		RAY_CAST_RESPONSE = hash("ray_cast_response"),
		APPLY_FORCE = hash("apply_force"),
		LINEAR_VELOCITY = hash("linear_velocity"),
}

M.EMPTY = hash("empty")
M.SPRITE = hash("sprite")
M.SPINE = hash("spine")
M.MESH = hash("mesh")
M.MODEL = hash("model")
M.EULER_X = hash("euler.x")
M.EULER_Y = hash("euler.y")
M.EULER_Z = hash("euler.z")
M.EULER = hash("euler")
M.TINT = hash("tint")
M.TINT_X = hash("tint.x")
M.TINT_Y = hash("tint.y")
M.TINT_Z = hash("tint.z")
M.TINT_W = hash("tint.w")
M.SCALE = hash("scale")

M.MASS = hash("mass")

M.ASYNC_LOAD = hash("async_load")
M.UNLOAD = hash("unload")

M.ENABLE = hash("enable")
M.DISABLE = hash("disable")
M.SET_PARENT = hash("set_parent")
M.SET_TIME_STEP = hash("set_time_step")

return M
