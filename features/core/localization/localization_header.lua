---@meta

---@alias LocalizationLanguageMap table<string, string>
---@alias LocalizationConfig table<string, LocalizationLanguageMap>

---@class LocalizationNativeModule
localization = localization or {}

---Load localization JSON from bundled resources and return a language map.
---@param resource_path string path inside the bundle, for example `"/custom/localization_compact.json"`
---@return LocalizationConfig localization_map
function localization.load_localization_from_resources(resource_path) end
