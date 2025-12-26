local CLASS = require "libs.class"
local SKIN3D_DEF = require "features.meta.skins.skins3d_def"
local ENUMS = require "game.enums"

local StoragePart = require "features.core.storage.storage_part"

---@class SkinsStoragePart:StoragePart
local Storage = CLASS.class("SkinsStoragePart", StoragePart)

function Storage.new(storage) return CLASS.new_instance(Storage, storage) end

function Storage:initialize(storage)
    StoragePart.initialize(self, storage)
    self.skins = self.storage.data.skins
    if not self.skins then
        self.skins = {}
        self.storage.data.skins = self.skins
    end
    self:check_skins_unlock()
end

function Storage:get_skin(skin_id)
    assert(SKIN3D_DEF.BY_ID[skin_id], "no skin:" .. skin_id)
    local skin = self.skins[skin_id]
    if not skin then
        skin = {
            unlocked = false,
        }
        self.skins[skin_id] = skin
        self:save()
    end
    return skin
end

function Storage:is_unlocked(skin_id)
    local skin = self:get_skin(skin_id)
    return skin.unlocked
end

function Storage:_check_skin_unlock(skin_def)
    local skin = self:get_skin(skin_def.id)
    if not skin.unlocked then
        if skin_def.unlock.type == ENUMS.SKIN_UNLOCK_TYPE.PLAYER_LEVEL then
            skin.unlocked = 1 >= skin_def.unlock.value
        end
    end
end

function Storage:check_skins_unlock()
    for _, skin_def in ipairs(SKIN3D_DEF.PLAYER_LIST_SKINS) do
        self:_check_skin_unlock(skin_def)
    end
end

function Storage:skin_buy(skin_id)
    local skin = self.skins[skin_id]
    if skin.unlocked then return end
    local skin_def = SKIN3D_DEF.SKINS.BY_ID[skin_id]
    if skin_def.unlock.type == ENUMS.SKIN_UNLOCK_TYPE.RESOURCE then
      --  if self.storage.resources:can_spend(DEFS.RESOURCES.BY_ID.GOLD.id, skin_def.unlock.value) then
          --  self.storage.resources:spend(DEFS.RESOURCES.BY_ID.GOLD.id, skin_def.unlock.value)
        --    self:unlocked(skin_id)
      --  end
    end
end

function Storage:unlocked(skin_id)
    local skin = self:get_skin(skin_id)
    skin.unlocked = true
    self:save_and_changed()
end

return Storage
