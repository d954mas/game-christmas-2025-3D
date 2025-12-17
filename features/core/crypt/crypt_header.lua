---@meta

---@class CryptSdk
crypt = {}

---Base64 encode a string.
---@param data string
---@return string|nil encoded
function crypt.encode_base64(data) end

---Encrypt data with XTEA and Base64 encode the result.
---@param data string plain-text to encrypt
---@param key string encryption key
---@return string encrypted base64 text
function crypt.encrypt(data, key) end

---Decrypt data created by `crypt.encrypt`.
---@param data string base64 encrypted payload
---@param key string encryption key
---@return string plain-text data
function crypt.decrypt(data, key) end
