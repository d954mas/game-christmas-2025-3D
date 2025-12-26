local CLASS = require "libs.class"
local StoragePart = require "features.core.storage.storage_part"

local PlayerItemsInHandStoragePart = CLASS.class("PlayerItemsInHandStoragePart", StoragePart)

function PlayerItemsInHandStoragePart.new(storage) return CLASS.new_instance(PlayerItemsInHandStoragePart, storage) end

function PlayerItemsInHandStoragePart:initialize(storage)
    StoragePart.initialize(self, storage)
    self.player = self.storage.data.player
    if not self.player.hand then
        self.player.hand_right_item = nil
        self.player.hand_left_item = nil
    end
end

function PlayerItemsInHandStoragePart:get_right_hand_item()
    return self.player.hand_right_item
end

function PlayerItemsInHandStoragePart:get_left_hand_item()
    return self.player.hand_left_item
end

function PlayerItemsInHandStoragePart:set_right_hand_item(item_id)
    self.player.hand_right_item = item_id
    self:save_and_changed()
end

function PlayerItemsInHandStoragePart:set_left_hand_item(item_id)
    self.player.hand_left_item = item_id
    self:save_and_changed()
end

---@class PlayerItemsInHandFeature:Feature
local PlayerItemsInHandFeature = {}

function PlayerItemsInHandFeature:on_storage_init(storage)
    self.storage = PlayerItemsInHandStoragePart.new(storage)
end

return PlayerItemsInHandFeature