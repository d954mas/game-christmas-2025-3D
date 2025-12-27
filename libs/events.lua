local Event = require "libs.event"

local M = {}
M.LANGUAGE_CHANGED = Event.new("LANGUAGE_CHANGED")
M.WINDOW_RESIZED = Event.new("WINDOW_RESIZED")
M.STORAGE_CHANGED = Event.new("STORAGE_CHANGED")
M.WINDOW_EVENT = Event.new("WINDOW_EVENT")
M.LOCATION_COLLECTED = Event.new("LOCATION_COLLECTED")




return M