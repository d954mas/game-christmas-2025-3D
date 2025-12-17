---@meta

---@class LfsAttributes
---@field dev number
---@field ino number
---@field mode string
---@field nlink number
---@field uid number
---@field gid number
---@field rdev number
---@field access number
---@field modification number
---@field change number
---@field size number
---@field permissions string
---@field blocks number
---@field blksize number
---@field type string

---@class LuaFileSystem
---@field _VERSION string
---@field _DESCRIPTION string
---@field _COPYRIGHT string
lfs = {}

---@param path string
---@param attr_name string|nil
---@return any|LfsAttributes
function lfs.attributes(path, attr_name) end

---@param path string
---@return boolean
function lfs.chdir(path) end

---@return string
function lfs.currentdir() end

---@param path string
---@return fun():string
function lfs.dir(path) end

---@param file userdata
---@param mode string
---@param start number
---@param length number
---@return boolean
function lfs.lock(file, mode, start, length) end

---@param path string
---@return boolean
function lfs.mkdir(path) end

---@param path string
---@return boolean
function lfs.rmdir(path) end

---@param file userdata
---@param mode string
---@return string|nil, string|nil
function lfs.setmode(file, mode) end

---@param path string
---@param attr_name string|nil
---@return any|LfsAttributes
function lfs.symlinkattributes(path, attr_name) end

---@param path string
---@param atime number|nil
---@param mtime number|nil
---@return boolean
function lfs.touch(path, atime, mtime) end

---@param file userdata
---@return boolean
function lfs.unlock(file) end
