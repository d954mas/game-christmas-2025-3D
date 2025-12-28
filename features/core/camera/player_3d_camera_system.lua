local CLASS = require "libs.class"
local ECS = require 'libs.ecs'
local CAMERAS = require "features.core.camera.cameras_feature"
local INPUT = require "features.core.input.input"
local LUME = require "libs.lume"
local HASHES = require "libs.hashes"
local SM = require "features.core.scenes.scene_manager.scene_manager"
local CAMERA_FEATURE = require "features.core.camera.cameras_feature"
local IMGUI_FEATURE = require "features.debug.imgui.imgui_feature"

local TEMP_V = vmath.vector3()
local TEMP_DIR = vmath.vector3()

local QUAT_X = vmath.quat_rotation_x(0)
local QUAT_Y = vmath.quat_rotation_y(0)

local RAYCAST_FROM = vmath.vector3()
local RAYCAST_TO = vmath.vector3()


---@class PlayerCameraSystem:EcsSystem
local System = CLASS.class("PlayerCameraSystem", ECS.System)
function System.new() return CLASS.new_instance(System) end

function System:initialize()
	ECS.System.initialize(self)
end

function System:clamp_angle(player)
	local camera = player.camera
	if camera.first_view then
		camera.angle_x.value = LUME.clamp(camera.angle_x.value, -math.pi / 2 * 0.98, math.pi / 2 * 0.98)
	else
		camera.angle_x.value = LUME.clamp(camera.angle_x.value, camera.angle_x.min, camera.angle_x.max)
	end
	camera.angle_y.value = LUME.clamp(camera.angle_y.value, camera.angle_y.min, camera.angle_y.max)
end

function System:update(_)
	local player = self.world.game_world.level_creator.player
	local camera = player.camera
	self:clamp_angle(player)

	xmath.quat_rotation_x(QUAT_X, camera.angle_x.value)
	xmath.quat_rotation_y(QUAT_Y, camera.angle_y.value)
	xmath.quat_mul(camera.rotation, QUAT_Y, QUAT_X)

	xmath.quat_to_euler(camera.rotation_euler, player.camera.rotation)

	local euler_x = camera.rotation_euler.x
	local euler_y = camera.rotation_euler.y
	local euler_z = camera.rotation_euler.z
	euler_y = LUME.angle_min_deg(euler_y)
	local dy_y_1 = math.abs(90 - euler_y)
	local dy_y_2 = math.abs(270 - euler_y)
	euler_y = dy_y_1 < dy_y_2 and dy_y_1 or dy_y_2
	if math.abs(euler_x) + math.abs(euler_z) > 7 or euler_y > 7 then
		xmath.quat(camera.rotation_billboard_gui, camera.rotation)
	else
		xmath.vector3_set_components(TEMP_V, camera.rotation_euler.x + 12, camera.rotation_euler.y, camera.rotation_euler.z)
		xmath.euler_to_quat(camera.rotation_billboard_gui, TEMP_V)
	end


	local zoom_value = CAMERA_FEATURE.storage:get_zoom()
	if SM:get_top() and SM:get_top()._name == "GameScene" and not IMGUI_FEATURE:is_imgui_handled_input() then
		if socket.gettime() - INPUT.get_key_data(HASHES.INPUT.SCROLL_UP).pressed_time < 0.05 then
			local a = (0.05 - (socket.gettime() - INPUT.get_key_data(HASHES.INPUT.SCROLL_UP).pressed_time)) / 0.05
			zoom_value = math.min(zoom_value - 0.5 / 18 * a, 1)
		end
		if socket.gettime() - INPUT.get_key_data(HASHES.INPUT.SCROLL_DOWN).pressed_time < 0.05 then
			local a = (0.05 - (socket.gettime() - INPUT.get_key_data(HASHES.INPUT.SCROLL_DOWN).pressed_time)) / 0.05
			zoom_value = math.min(zoom_value + 0.5 / 18 * a, 1)
		end
	end
	CAMERA_FEATURE.storage:set_zoom(zoom_value)

	self:update_zoom()
	CAMERAS.CAMERAS.GAME_3D:set_rotation(camera.rotation)
end

function System:update_zoom()
	local player = self.world.game_world.level_creator.player
	local camera = player.camera
	camera.distance.last_value = camera.distance.value
	local cam_min = camera.distance.min
	local cam_max = camera.distance.max
	if RENDER.screen_size.aspect<1 then
		cam_min = camera.distance.min_album
		cam_max = camera.distance.max_album
	end
	camera.distance.value = cam_min + (cam_max - cam_min) * CAMERA_FEATURE.storage:get_zoom()

    --some zoom limits
	if camera.distance.value > 4 and camera.distance.value < 6 then
		camera.distance.value = 5
	end
	if camera.distance.value <= 4 then
		camera.distance.value = 0
	end

	if camera.distance.value < 3 then
		TEMP_V.x, TEMP_V.y, TEMP_V.z = 0, 2, 0
		xmath.rotate(TEMP_V, camera.rotation, TEMP_V)
		xmath.add(camera.position, player.position, TEMP_V)
	else
		TEMP_V.x, TEMP_V.y, TEMP_V.z = 0, 0, camera.distance.value
		xmath.rotate(TEMP_V, camera.rotation, TEMP_V)
		xmath.add(camera.position, player.position, TEMP_V)
		camera.position.y = camera.position.y + 0.5
	end


	RAYCAST_TO.x = camera.position.x
	RAYCAST_TO.y = camera.position.y
	RAYCAST_TO.z = camera.position.z

	RAYCAST_FROM.x = player.position.x
	RAYCAST_FROM.y = player.position.y + 1
	RAYCAST_FROM.z = player.position.z

	local exist, x, y, z, _, _, _ = false, 0, 0, 0, 0, 0, 0 --game.physics_raycast_single(RAYCAST_FROM, RAYCAST_TO, self.camera_raycast_mask)
	if self.world.game_world.state.editor_visible then
		exist = false
	end
	if exist then
		TEMP_DIR.x, TEMP_DIR.y, TEMP_DIR.z = x - player.position.x, y - player.position.y, z - player.position.z
		local distance = vmath.length(TEMP_DIR)
		distance = distance - 0.25
		if distance < 4 then
			distance = 0
		end
		--xmath.normalize(TEMP_DIR, TEMP_DIR)
		--xmath.mul(TEMP_DIR, TEMP_DIR, distance)
		--camera.position.x = TEMP_DIR.x
		--camera.position.y = TEMP_DIR.y
		--camera.position.z = TEMP_DIR.z
		camera.distance.value = distance
	end

	local new_distance = LUME.lerp(camera.distance.last_value, camera.distance.value, 0.15)
	camera.distance.last_value = camera.distance.value
	camera.distance.value = new_distance
	TEMP_V.x, TEMP_V.y, TEMP_V.z = 0, 0, new_distance

	if new_distance < 1 then
		TEMP_V.x, TEMP_V.y, TEMP_V.z = 0, 2, 0
		xmath.add(camera.position, player.position, TEMP_V)
		camera.first_view = true
	else
		camera.first_view = false
		xmath.rotate(TEMP_V, camera.rotation, TEMP_V)
		xmath.add(camera.position, player.position, TEMP_V)
		camera.position.y = camera.position.y + 0.5
	end

	local dz = (camera.distance.value - cam_min) / (cam_max - cam_min)
	camera.position.z = camera.position.z - 1 - 7 * dz

	if camera.position.y < -0.5 then
		camera.position.y = -0.5
	end

	CAMERAS.CAMERAS.GAME_3D:set_position(camera.position)
end

return System
