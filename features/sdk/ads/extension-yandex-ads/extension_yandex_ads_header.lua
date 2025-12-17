---@meta

---@class YandexAdsMessage
---@field event number one of `yandexads.EVENT_*`
---@field error string|nil optional error description for failed events
---@field data string|nil optional JSON string with impression data (Android)
---@field impression string|nil optional JSON string with impression data (iOS)
---@field amount number|nil reward amount for rewarded placements (iOS)
---@field type string|nil reward type identifier (iOS)

---@alias YandexAdsCallback fun(self:any, message_id:number, message:YandexAdsMessage)

---@class YandexAdsSdk
yandexads = {}

---@param callback YandexAdsCallback|nil callback receiving ads events. Pass `nil` to remove callback
function yandexads.set_callback(callback) end

---Initialize the Yandex Ads SDK.
function yandexads.initialize() end

---Enable verbose logging from the native SDK (dev builds only).
function yandexads.enable_logging() end

---Configure user consent for personalized ads.
---@param consent boolean
function yandexads.set_user_consent(consent) end

---Load a banner ad.
---@param unit_id string ad placement identifier
---@param width number|nil optional width in pixels
---@param height number|nil optional height in pixels
function yandexads.load_banner(unit_id, width, height) end

---Check if a banner is ready.
---@return boolean
function yandexads.is_banner_loaded() end

---Show the loaded banner.
---@param position number|nil optional position constant, default `yandexads.POS_BOTTOM_CENTER`
function yandexads.show_banner(position) end

---Hide the currently shown banner if any.
function yandexads.hide_banner() end

---Destroy the loaded banner and release resources.
function yandexads.destroy_banner() end

---Load an interstitial ad.
---@param unit_id string ad placement identifier
function yandexads.load_interstitial(unit_id) end

---Check if an interstitial is ready.
---@return boolean
function yandexads.is_interstitial_loaded() end

---Show a loaded interstitial.
function yandexads.show_interstitial() end

---Load a rewarded ad.
---@param unit_id string ad placement identifier
function yandexads.load_rewarded(unit_id) end

---Check if a rewarded ad is ready.
---@return boolean
function yandexads.is_rewarded_loaded() end

---Show a loaded rewarded ad.
function yandexads.show_rewarded() end

---@type number
yandexads.MSG_ADS_INITED = 0
---@type number
yandexads.MSG_INTERSTITIAL = 1
---@type number
yandexads.MSG_REWARDED = 2
---@type number
yandexads.MSG_BANNER = 3

---@type number
yandexads.EVENT_LOADED = 0
---@type number
yandexads.EVENT_ERROR_LOAD = 1
---@type number
yandexads.EVENT_SHOWN = 2
---@type number
yandexads.EVENT_DISMISSED = 3
---@type number
yandexads.EVENT_CLICKED = 4
---@type number
yandexads.EVENT_IMPRESSION = 5
---@type number
yandexads.EVENT_NOT_LOADED = 6
---@type number
yandexads.EVENT_REWARDED = 7
---@type number
yandexads.EVENT_DESTROYED = 8
---@type number
yandexads.EVENT_FAILED_TO_SHOW = 9

---@type number
yandexads.POS_NONE = 0
---@type number
yandexads.POS_TOP_LEFT = 1
---@type number
yandexads.POS_TOP_CENTER = 2
---@type number
yandexads.POS_TOP_RIGHT = 3
---@type number
yandexads.POS_BOTTOM_LEFT = 4
---@type number
yandexads.POS_BOTTOM_CENTER = 5
---@type number
yandexads.POS_BOTTOM_RIGHT = 6
---@type number
yandexads.POS_CENTER = 7
