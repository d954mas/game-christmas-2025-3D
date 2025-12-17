local LOG = require "libs.log"
local CONTEXTS = require "libs.contexts_manager"
local CONSTANTS = require "libs.constants"

local TAG = "Liveupdate"


local M = {
	VERSION = 1,
	ATTEMPT_DELAY = 0.25,
	PATH = "./", ---Here we indicate the path to the file. I set root folder
	cb = nil,
	attempts = 0,
	load_size = 1231005
}
M.NAME = "liveupdate_resources" .. M.VERSION .. ".zip"


function M.load(cb)
	assert(M.attempts == 0)
	M.attempts = M.attempts + 1


	if not liveupdate or not html5 then
		LOG.i("NO LIVEUPDATE. SKIP", TAG)
		cb()
		return
	end

	local old_mounts = {}
	for i = 1, M.VERSION - 1 do
		old_mounts["liveupdate_resources" .. i .. ".zip"] = true
	end

	local mounts = liveupdate.get_mounts()
	local already_mounted = false
	for _, mount in pairs(mounts) do
		if old_mounts[mount.name] then
			LOG.i("remove old mount:" .. mount.name, TAG)
			liveupdate.remove_mount(mount.name)
		elseif M.NAME == mount.name then
			already_mounted = true
		end
	end
	if already_mounted then
		LOG.i("ALREADY MOUNTED. SKIP", TAG)
		cb()
		return
	end
	M.cb = cb
	--if html_utils then html_utils.liveupdate_load() end
	M.__request_data()
end

function M.__request_data()
	http.request(M.PATH .. M.NAME, "GET", function (_, _, response)
		if response.bytes_total ~= nil then
			local percentage = 0
			if response.bytes_total ~= 0 then
				percentage = response.bytes_received / response.bytes_total
			else
				percentage = response.bytes_received / M.load_size
			end
			if html_utils then
				--progress bar show liveupdate loading
				html_utils.liveupdate_load_set_percentage(percentage * 100)
			end
			LOG.i("liveupdate loaded " .. percentage, TAG)
		else
			html_utils.liveupdate_load_set_percentage(100)
			if (response.status == 200 or response.status == 304) and response.error == nil and response.response ~= nil then
				M.__on_load_done(response.response)
			else
				---If unsuccessful, I make several attempts to load the data.
				M.attempts = M.attempts + 1
				local delay = M.ATTEMPT_DELAY
				if M.attempts > 1000 then
					delay = 10
				elseif M.attempts > 100 then
					delay = 1
				end
				timer.delay(delay, false, function ()
					M.__request_data()
				end)
			end
		end
	end, nil, nil)
end

function M.__on_load_done(response)
	local new_path = sys.get_save_file(CONSTANTS.GAME_ID, M.NAME)
	---Create a file object to work with IndexedDB
	local file, err = io.open(new_path, "w+")
	if not file or err then
		LOG.e(err)
		M.__request_data()
		return
	end
	---Write our received data to IndexedDB
	local _, err2 = file:write(response)
	if err2 then
		LOG.e(err2)
		M.__request_data()
		return
	end
	---Close connection
	file:close()
	---Add new mount
	liveupdate.add_mount(M.NAME, "zip:" .. new_path, M.VERSION, function ()
		local cb = M.cb
		M.cb = nil
		cb()
	end)
end

function M.is_ready()
	return CONTEXTS:exist(CONTEXTS.NAMES.LIVEUPDATE_COLLECTION)
end

return M
