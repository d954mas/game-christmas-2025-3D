---@meta

---@class SafeAreaInsets
---@field top number
---@field right number
---@field bottom number
---@field left number

---@class SafeAreaSdk
safearea = {}

---Get safe area insets for the current device.
---@return SafeAreaInsets insets
---@return number status one of `safearea.STATUS_*`
function safearea.get_insets() end

---@type number
safearea.STATUS_NOT_READY_YET = 0
---@type number
safearea.STATUS_OK = 1
---@type number
safearea.STATUS_ERROR = 2
