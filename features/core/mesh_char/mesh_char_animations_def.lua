local M = {}

M.BY_ID = {
	RUN_BASE = { file = "pistol_run.bin" },
	LOOK_AROUND = { file = "look_around.bin" },
	PICKAXE_ATTACK = { file = "pickaxe_attack.bin" },
}

M.BONES = {
	Object = -1,
	Root = 0,
	Body = 1,
	Chest = 2,
	Head = 3,
	Head_end = 4,
	Arm_Left_Upper = 5,
	Arm_Left_Lower = 6,
	Arm_Left_Lower_end = 7,
	Arm_Right_Upper = 8,
	Arm_Right_Lower = 9,
	Arm_Right_Lower_end = 10,
	Leg_Right_Upper = 11,
	Leg_Right_Lower = 12,
	Leg_Right_Lower_end = 13,
	Leg_Left_Upper = 14,
	Leg_Left_Lower = 15,
	Leg_Left_Lower_end = 16,
}

M.BONES_WEIGHS = {
	ARM_ATTACK = {
		[M.BONES.Object] = 1,
		[M.BONES.Root] = 1,
		[M.BONES.Body] = 1,
		[M.BONES.Chest] = 1,
		[M.BONES.Head] = 1,
		[M.BONES.Head_end] = 1,

		[M.BONES.Leg_Right_Upper] = 0.25,
		[M.BONES.Leg_Right_Lower] = 0.25,
		[M.BONES.Leg_Right_Lower_end] = 0.25,
		[M.BONES.Leg_Left_Upper] = 0.25,
		[M.BONES.Leg_Left_Lower] = 0.25,
		[M.BONES.Leg_Left_Lower_end] = 0.25,

		[M.BONES.Arm_Left_Upper] = 3,
		[M.BONES.Arm_Left_Lower] = 3,
		[M.BONES.Arm_Left_Lower_end] = 3,
		[M.BONES.Arm_Right_Upper] = 3,
		[M.BONES.Arm_Right_Lower] = 3,
		[M.BONES.Arm_Right_Lower_end] = 3,
	},
}

M.LOAD_LIST = {}

for k, v in pairs(M.BY_ID) do
	v.id = k
	table.insert(M.LOAD_LIST, v)
end

return M