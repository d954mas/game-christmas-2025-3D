local LOG = require "libs.log"
local FIREBASE = require "features.sdk.analytics.firebase"
local GAME_ANALYTICS = require "features.sdk.analytics.gameanalytics"
local TAG = "Analytics"

---@class Analytics
local Analytics = {
	wasm_memory = {
		heap_size = sys.get_config_number("html5.heap_size", 64.0) * 1024 * 1024,
	}
}

---add analytics to log to log warning and errors
LOG.ANALYTICS = Analytics

function Analytics:init()
	GAME_ANALYTICS:init()
	FIREBASE:init()

	if html5 then
		--check every 60 seconds if heap size is exceeded
		timer.delay(60, true, function ()
			local heap_size = tonumber(html5.run("Module.HEAP8.length"))
			if heap_size > self.wasm_memory.heap_size then
				self.wasm_memory.heap_size = heap_size
				LOG.e("WASM memory exceeded " .. (self.wasm_memory.heap_size / 1024 / 1024) .. "MB", TAG)
			end
		end)
	end
end

---@param message string
function Analytics:error(message)
	GAME_ANALYTICS:error(message)
	FIREBASE:error(message)
end

---Project events
function Analytics:game_loaded()
	GAME_ANALYTICS:event("game:loaded")
	FIREBASE:event("game_loaded")
end

function Analytics:gameplay_start()
	if not self.gameplay_start_event_send then
		GAME_ANALYTICS:event("game:gameplay_start")
		FIREBASE:event("gameplay_start")
		self.gameplay_start_event_send = true
	end
end

function Analytics:scene_hide(name)
	GAME_ANALYTICS:event("scene:" .. name .. ":hide")
	FIREBASE:event_table("scene_hide", {
		name = name
	})
end

function Analytics:scene_show(name)
	GAME_ANALYTICS:event("scene:" .. name .. ":show")
	FIREBASE:event_table("scene_show", {
		name = name
	})
end

function Analytics:ads_start(name)
	name = name or "unknown"
	GAME_ANALYTICS:event("ads:" .. name .. ":start")
	FIREBASE:event_table("ads_start", {
		name = name
	})
end

function Analytics:ads_result(name, success)
	name = name or "unknown"
	GAME_ANALYTICS:event("ads:" .. name .. ":" .. (success and "success" or "fail"))
	FIREBASE:event_table("ads_result", {
		name = name,
		success = success
	})
end

function Analytics:first_play()
	GAME_ANALYTICS:event("game:first_play")
	FIREBASE:event("game_first_play")
end

function Analytics:event_ads_revenue_yandex(ad_unit_name, data)
	data = assert(json.decode(data))
	local event = {
		ad_platform = "yandex",
		ad_source = data.network.name,
		ad_format = data.adType,
		ad_unit_name = ad_unit_name,
		value = tonumber(data.revenue),
		currency = data.currency
	}
	FIREBASE:event_table("ad_impression", event)
end

function Analytics:level_loaded(level_name)
	GAME_ANALYTICS:event("game:level:" .. level_name .. ":load")
	FIREBASE:event_string("game_level_loaded", "level", level_name)
end

function Analytics:location_loaded(level_name)
	GAME_ANALYTICS:event("game:location:" .. level_name .. ":load")
	FIREBASE:event_string("game_location_loaded", "level", level_name)
end

function Analytics:building_build(location_id, building_id)
	GAME_ANALYTICS:event("building:" .. location_id .. ":" .. building_id .. ":build")
	FIREBASE:event_table("building_build", {
		location_id = location_id,
		building_id = building_id
	})
end

return Analytics
