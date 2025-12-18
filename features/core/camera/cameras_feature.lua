local CamerasStoragePart = require "features.core.camera.cameras_storage_part"
---@class CamerasFeature:Feature
local M = {
    CAMERAS = {
        GAME = native_camera.new({
            orthographic = false,
            fov = math.rad(60),
            near_z = 0.01,
            far_z = 350,
        })
    }
}

M.current_camera = M.CAMERAS.GAME

M.current_camera:set_position(vmath.vector3(0, 0, 0))

function M:on_resize(width, height)
    for _, v in pairs(self.CAMERAS) do
        v:set_screen_size(width, height)
    end
end

function M:on_storage_init(storage)
    self.storage = CamerasStoragePart.new(storage)
end

return M
