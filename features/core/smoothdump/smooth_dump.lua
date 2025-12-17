-- https://stackoverflow.com/questions/61372498/how-does-mathf-smoothdamp-work-what-is-it-algorithm
local LUME = require "libs.lume"
local CLASS = require "libs.class"

local function shortestAngleDiff(targetAngle, currentAngle)
	local difference = targetAngle - currentAngle
	difference = (difference + math.pi) % (2 * math.pi) - math.pi
	-- Всегда выбираем положительное направление при точных 180°
	if difference == -math.pi then
		difference = math.pi
	end
	return -difference
end

local SmoothDamp = CLASS.class("SmoothDamp")

function SmoothDamp.new(smoothTime, maxSpeed)
	return CLASS.new_instance(SmoothDamp, smoothTime, maxSpeed)
end

function SmoothDamp:initialize(smoothTime, maxSpeed)
	self.smoothTime = smoothTime or 1
	self.maxSpeed = maxSpeed or math.huge
	self.currentVelocity = 0
	self.maxDelta = 0.001
end

function SmoothDamp:update(current, target, dt)
	-- Based on Game Programming Gems 4 Chapter 1.10
	local smoothTime = math.max(0.0001, self.smoothTime)
	local omega = 2 / smoothTime

	local x = omega * dt;
	local exp = 1 / (1 + x + 0.48 * x * x + 0.235 * x * x * x);
	local change = current - target;
	local originalTo = target;

	-- Clamp maximum speed
	local maxChange = self.maxSpeed * smoothTime;
	change = LUME.clamp(change, -maxChange, maxChange);
	target = current - change;

	local temp = (self.currentVelocity + omega * change) * dt;
	self.currentVelocity = (self.currentVelocity - omega * temp) * exp;
	local output = target + (change + temp) * exp;

	-- Prevent overshooting
	if ((originalTo - current > 0.0) == (output > originalTo)) then
		output = originalTo;
		self.currentVelocity = (output - originalTo) / dt;
	end
	if (math.abs(target - output) < self.maxDelta) then
		self.currentVelocity = 0
		return target
	end
	return output;
end

function SmoothDamp:updateAngle(currentAngle, targetAngle, dt)
	local smoothTime = math.max(0.0001, self.smoothTime)
	local omega = 2 / smoothTime

	local x = omega * dt
	local exp = 1 / (1 + x + 0.48 * x * x + 0.235 * x * x * x)

	-- Compute the shortest path difference between currentAngle and targetAngle in radians
	local change = shortestAngleDiff(targetAngle, currentAngle)
	local originalTo = targetAngle - change -- Adjust target based on shortest path

	-- Clamp maximum speed (the rest remains unchanged)
	local maxChange = self.maxSpeed * smoothTime
	change = LUME.clamp(change, -maxChange, maxChange)
	targetAngle = currentAngle - change

	local temp = (self.currentVelocity + omega * change) * dt
	self.currentVelocity = (self.currentVelocity - omega * temp) * exp
	local output = targetAngle + (change + temp) * exp

	-- Check for overshooting with the adjusted target
	if ((originalTo - currentAngle > 0.0) == (output > originalTo)) then
		output = originalTo
		self.currentVelocity = (output - originalTo) / dt
	end

	-- Final check to ensure we don't overshoot our target
	if (math.abs(targetAngle - output) < self.maxDelta) then
		self.currentVelocity = 0
		return targetAngle
	end

	return output
end

return SmoothDamp
