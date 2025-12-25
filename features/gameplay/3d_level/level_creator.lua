local CLASS = require "libs.class"
local LocationData = require "features.gameplay.3d_level.location_data"


---@class LevelCreator3D
local Creator = CLASS.class("LevelCreator3D")

function Creator.new(game_world) return CLASS.new_instance(Creator, game_world) end

---@param game_world GameWorld3D
function Creator:initialize(game_world)
	self.game_world = assert(game_world)
	self.ecs = game_world.ecs
	self.entities = game_world.ecs.entities
	self.location_data = LocationData.new(game_world)
	self.location_go = {
		id = nil,
		root_url = nil,
	}
end

function Creator:unload_location()
	if self.location_go.id then
		print("Unload location:" .. self.location_go.id)
		self.location_go.id = nil
		self.location_go.urls = nil
		go.delete(self.location_go.root_url, true)
		self.location_go.root_url = nil
	end
	self.player = nil
end

function Creator:create_location(location_id)
	self:unload_location()
	print("Start load location:" .. location_id)
	local time = chronos.nanotime()
	self.location_data:load(location_id)
	self.location_data:clear_location_storage()
	self:spawn_objects()
	print("Load location time:" .. (chronos.nanotime() - time))
end

function Creator:spawn_objects()
	for i = 1, #self.location_data.data.objects do
		local object = self.location_data.data.objects[i]
		self.ecs:add_entity(self.entities:create_object(object))
	end
end

function Creator:create_player(position)
	self.player = self.entities:create_player(position)
	self.ecs:add_entity(self.player)
end

return Creator
