local CONSTANTS = require "libs.constants"
local LOG = require "libs.log"
local EVENTS = require "libs.events"
local FEATURES = require "features.features"

local TAG = "Storage"

---@class Storage
local Storage = {
	FILE_PATH = CONSTANTS.GAME_ID,
	VERSION = 1,
	AUTOSAVE = 30,
	LOCAL = CONSTANTS.VERSION_IS_DEV and CONSTANTS.PLATFORM_IS_PC and CONSTANTS.TARGET_IS_EDITOR,
	prev_save_time = socket.gettime(),
	save_on_update = false,
	change_flag = false,
	---@type Sdks
	sdk = nil
}

function Storage:_init_storage()
	LOG.i("init new", TAG)
	---@class StorageData
	local data = {
		version = 1
	}

	self.data = data
end

function Storage:_migration()
	if (self.data.version < Storage.VERSION) then
		LOG.i(string.format("migrate from:%s to %s", self.data.version, Storage.VERSION), TAG)

		if (self.data.version < 1) then
			self:_init_storage()
		end
		self.data.version = Storage.VERSION
	end
end

function Storage:init()
	if Storage.LOCAL then
		self.path = "./storage.json"
	else
		self.path = Storage.FILE_PATH
		if (CONSTANTS.VERSION_IS_DEV) then
			self.path = self.path .. "_dev"
		end
		if not html5 then
			self.path = sys.get_save_file(self.path, "storage.json")
		end
	end

	local status, error = pcall(self._load_storage, self)
	if (not status) then
		LOG.e("error load storage:" .. tostring(error), TAG)
		self:_init_storage()
	end
	self:_migration()
	FEATURES:on_storage_init()
	self:save(true)
	self:changed()
end

function Storage:_load_storage()
	local data = nil
	if (html5) then
		local status, html_data = html_utils.load_data(self.path)
		if (not status) then
			if html_data == "no data" then
				LOG.i("html5 no data", TAG)
			else
				LOG.e("html5 error:" .. html_data, TAG)
			end
		else
			LOG.i("html5 data:" .. html_data, TAG)
			local status_json, file_data = pcall(json.decode, html_data)
			if (not status_json) then
				LOG.e("can't parse json:" .. tostring(file_data), TAG)
			else
				data = file_data
			end
		end
	else
		local status, file = pcall(io.open, self.path, "r")
		if (not status) then
			LOG.e("can't open file:" .. self.path, TAG)
		else
			if (file) then
				LOG.i("load", TAG)
				local contents, read_err = file:read("*a")
				if (not contents) then
					LOG.e("can't read file:\n" .. read_err, TAG)
				else
					LOG.i("read file:" .. self.path, TAG)
					local status_json, file_data = pcall(json.decode, contents)
					if (not status_json) then
						LOG.e("can't parse json:" .. tostring(file_data), TAG)
					else
						data = file_data
					end
				end
				file:close()
			else
				LOG.i("no file", TAG)
			end
		end
	end


	if (data) then
		if (data.encrypted) then
			data = crypt.decrypt(data.data, CONSTANTS.CRYPTO_KEY)
		else
			data = data.data
		end

		local result, storage = pcall(json.decode, data)
		if (result) then
			self.data = assert(storage)
		else
			LOG.e("can't parse json:" .. tostring(storage), TAG)
			self:_init_storage()
		end
		LOG.i("data:\n" .. tostring(data), TAG)
	else
		LOG.i("no data.Init storage", TAG)
		self:_init_storage()
	end
	LOG.i("loaded", TAG)
end

function Storage:changed()
	self.change_flag = true
end

function Storage:update()
	if (self.change_flag) then
		EVENTS.STORAGE_CHANGED:trigger()
		self.change_flag = false
	end
	if (self.save_on_update) then
		self:save(true)
	end
	if (socket.gettime() - self.prev_save_time > Storage.AUTOSAVE) then
		LOG.i("autosave", TAG)
		self:save(true)
	end
end

function Storage:reset()
	self:_init_storage()
	self:_migration()
	FEATURES:on_storage_init()
	self:save(true)
	self:changed()
end

function Storage:__save()
	local data = {
		data = json.encode(self.data),
	}
	data.encrypted = not Storage.LOCAL

	if (data.encrypted) then
		data.data = crypt.encrypt(data.data, CONSTANTS.CRYPTO_KEY)
	end

	local encoded_data = json.encode(data)

	if (html5) then
		local status, error = html_utils.save_data(self.path, encoded_data)
		if not status then
			LOG.e("save error:" .. error, TAG)
		end
	else
		local file = io.open(self.path, "w+")
		if (not file) then
			LOG.e("can't open file:" .. tostring(file), TAG)
			return
		end
		file:write(encoded_data)
		file:close()
	end
end

function Storage:save(force)
	if (force) then
		LOG.i("save", TAG)
		self.prev_save_time = socket.gettime()
		local status, error = pcall(self.__save, self)
		if (not status) then
			LOG.e("error save storage:" .. tostring(error), TAG)
		end
		self.save_on_update = false
	else
		self.save_on_update = true
	end
end

return Storage
