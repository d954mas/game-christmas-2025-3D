local CLASS = require "libs.class"
local SKIN_DEF = require "features.meta.skins.skins3d_def"
local StoragePart = require "features.core.storage.storage_part"

local PlayerSkinStoragePart = CLASS.class("PlayerSkinStoragePart", StoragePart)

function PlayerSkinStoragePart.new(storage) return CLASS.new_instance(PlayerSkinStoragePart, storage) end

function PlayerSkinStoragePart:initialize(storage)
    StoragePart.initialize(self, storage)
    self.player = self.storage.data.player
    if not self.player.skin then
        self.player.skin = SKIN_DEF.PLAYER_LIST_SKINS[1]
    end
end

function PlayerSkinStoragePart:get_skin()
    return self.player.skin
end

function PlayerSkinStoragePart:set_skin(skin)
    self.player.skin = skin
    self:save_and_changed()
end

---@class PlayerSkinFeature:Feature
local PlayerSkinFeature = {}

function PlayerSkinFeature:on_storage_init(storage)
    self.storage = PlayerSkinStoragePart.new(storage)
end

return PlayerSkinFeature