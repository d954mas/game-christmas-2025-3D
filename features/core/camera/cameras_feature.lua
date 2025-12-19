local CamerasStoragePart = require "features.core.camera.cameras_storage_part"
---@class CamerasFeature:Feature
local M = {
    CAMERAS = {
        GAME_3D = native_camera.new({
            orthographic = false,
            fov = math.rad(60),
            near_z = 0.01,
            far_z = 350,
        }),
        GAME_2D_PORTRAIT = native_camera.new({
            orthographic = true,
            near_z = -300,
            far_z = 25,
            ortho_scale = 1,
            ortho_scale_mode = native_camera.SCALE_MODE.FIXEDAREA,
            view_area_width = 270,
            view_area_height = 480,
        }),
         GAME_2D_ALBUM = native_camera.new({
            orthographic = true,
            near_z = -300,
            far_z = 25,
            ortho_scale = 1,
            ortho_scale_mode = native_camera.SCALE_MODE.FIXEDAREA,
            view_area_width = 480,
            view_area_height = 270,
        }),
    }
}

M.current_camera = M.CAMERAS.GAME_2D_ALBUM

function M:on_resize(width, height)
    for _, v in pairs(self.CAMERAS) do
        v:set_screen_size(width, height)
    end
end

function M:on_storage_init(storage)
    self.storage = CamerasStoragePart.new(storage)
end

return M
