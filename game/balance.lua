local M = {}

function M:init()
    self.config = {
        physics_scale = 2 / 16, --tile is 2 meter
        tile_size = 16,
        player_speed = 100,
        z_order = {
            TILE_MAP_Z1 = 0,
            TILE_MAP_Z2 = 100,
        },
        camera_dy = 80, --камера немного выше а не по центру
    }
end

return M
