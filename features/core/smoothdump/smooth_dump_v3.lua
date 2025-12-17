--https://github.com/Sleitnick/AeroGameFramework/blob/master/src/StarterPlayer/StarterPlayerScripts/Aero/Modules/Smooth/SmoothDamp.lua

local CLASS = require "libs.class"

local SmoothDamp = CLASS.class("SmoothDamp")

function SmoothDamp.new(smoothTime, maxSpeed, maxDistance)
	return CLASS.new_instance(SmoothDamp, smoothTime, maxSpeed, maxDistance)
end

function SmoothDamp:initialize(smoothTime, maxSpeed, maxDistance)
	self.velocity = vmath.vector3()
	self.smoothTime = smoothTime or 0.25
	self.maxSpeed = maxSpeed or math.huge
	self.maxDistance = maxDistance or math.huge
end

function SmoothDamp:update(current, target, dt)
	smooth_dump.smooth_dump_v3(current, target, self.velocity, self.smoothTime, self.maxSpeed, self.maxDistance, dt)
end

return SmoothDamp
