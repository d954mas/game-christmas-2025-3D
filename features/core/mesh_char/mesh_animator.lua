local CLASS = require "libs.class"
local LUME = require "libs.lume"


local MOD_F = math.modf
local MATH_CEIL = math.ceil
local MATH_FLOOR = math.floor
local MATH_MIN = math.min
local CLAMP = LUME.clamp


local Anim = CLASS.class("Animation")

function Anim.new(mesh) return CLASS.new_instance(Anim, mesh) end

---@param mesh BinMesh
function Anim:initialize(mesh)
	self.time = 0
	self.fps = 30
	self.mesh = assert(mesh)
	self.animations = mesh.mesh_data.animations

	self.animation = nil
	self.frame = 1
	self.loops = 0

	self.track = 1

	self.blend = {
		---@type MeshAnimation|nil
		animation = nil,
		from = nil,
		to = nil,
		len = 0,
		last_blend_frame = nil,
		blend = 0,
		time = 0,
		duration = 0,
	}
end

function Anim:play(anim_name, config, cb)
	local current = self.animation
	self.animation = assert(self.animations[anim_name])
	self.playback_rate = config.playback_rate or 1
	self.time = 0
	self.duration = self.animation.length / self.fps
	self.loops = 1
	self.finish_cb = cb
	self.delay = config.delay or 0

	if config then
		self.loops = config.loops or self.loops
		self.playback_rate = config.playback_rate or self.playback_rate
	end

	if config and config.blend_duration and current then
		assert(config.blend_duration >= 0)
		self.blend.animation = current
		self.blend.from = self.frame
		self.blend.to = MATH_FLOOR(self.blend.from + self.fps * config.blend_duration)
		self.blend.len = (self.blend.to - self.blend.from + 1)
		self.blend.last_blend_frame = current.finish
		self.blend.blend = 1
		self.blend.time = 0
		self.blend.duration = config.blend_duration
	end

	self.frame = self.animation.start
	--self.mesh:set_frame(self.blend.active and self.blend.from or self.frame)
end

function Anim:is_finished() return self.loops == 0 end

function Anim:update(dt)
	if not self:is_finished() then
		self.time = self.time + dt * self.playback_rate
		if self.delay > 0 then
			self.delay = self.delay - dt
			self.time = 0.1
		end
		local a = self.time / self.duration
		local full, part = MOD_F(a)

		if full >= 1 then
			self.time = self.time - self.duration * full
			self.loops = self.loops - 1
		end

		--clamp last frame
		if self.loops == 0 then
			part = 1
		end

		local new_frame = self.animation.start + CLAMP(MATH_FLOOR(self.animation.length * part), 0, self.animation.length - 1)

		if self.blend.duration > 0 then
			self.blend.time = self.blend.time + dt
			local blend_a = MATH_MIN(1, self.blend.time / self.blend.duration)
			if blend_a >= 1 then self.blend.duration = 0 end
			local last_blend_frame = self.blend.from + MATH_CEIL(self.blend.len * blend_a)
			last_blend_frame = CLAMP(last_blend_frame, self.blend.from, self.blend.to)

			self.frame = new_frame
			self.blend.last_blend_frame = last_blend_frame
			self.mesh:set_frame(self.track, self.frame, MATH_MIN(self.blend.last_blend_frame, self.blend.animation.finish), 1 - blend_a)
		else
			if new_frame ~= self.frame then
				self.frame = new_frame
				self.mesh:set_frame(self.track, self.frame)
			end
		end

		if self.loops == 0 then
			self.blend.duration = 0
			if self.finish_cb then
				local cb = self.finish_cb
				self.finish_cb = nil
				cb()
			end
		end
	end
end

return Anim
