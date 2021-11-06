Animator = {}
Animator.__index = Animator
Animator._animations = {}
Animator._index = 0
Animator._frameIndex = 0
Animator._frameTime = os.time()
Animator._smoothedFps = 30.0 -- Start expecting 30 fps (calibration will adjust this accordingly, starting from zero is alot slower though)
Animator._lastUpdate = -10
Animator._stableFramerate = true
Animator._frameRateCb = nil

onTimer = function () end

-- Override timer callback
onTimer = function ()   
	Animator._frameIndex = Animator._frameIndex + 1

	-- Naive implementation to figure approximate frame rate we're called
	-- Lua's timekeeping is pretty rough, so we can't expect accuracy below 1 second. 
	-- This method also has the benefit of adjusting over time; so if the timer ticks aren't solid 
	-- the animations will speed up or slow down accordingly to keep the transistion time according to the requested value
	if os.difftime(os.time() , Animator._frameTime) >= 1.0 then 
		Animator._frameTime = os.time()
		-- print("FPS " .. Animator._frameIndex .. " smoothed " .. Animator._smoothedFps .. " frametime " .. (1.0/Animator._smoothedFps*1000))
		Animator._smoothedFps = (Animator._smoothedFps + Animator._frameIndex) / 2 -- Simple low pass filter the value to approximate average
		local diff = math.abs(Animator._lastUpdate - Animator._frameIndex) 
		if diff <= 1 then
			Animator._stableFramerate = true
		end
		Animator._lastUpdate = Animator._frameIndex
		Animator._frameIndex = 0
		if Animator._frameRateCb then
			Animator._frameRateCb(Animator._smoothedFps, not Animator._stableFramerate)
		end
	end

	if Animator._active then
		Animator.process()
	end
end

-- Add an animation to the queue
Animator.submit = function (Animation) 
--	print("Submit animation")
--	print(debug.traceback())
	Animator._animations[Animator._index] = Animation
	Animator._index = Animator._index + 1
	Animation:setTimebase(Animator.getTimebase())
	Animator.start()
end

Animator._driver = nil

-- Start all queued animations if suspended, else no-op
Animator.start = function ()
	Animator._active = true
	-- Animator._frameTime = os.time()
	-- Animator._frameTime = 0
end

Animator.stop = function () 
	Animator._active = false
end

Animator._wrapper = function () 
	onTimer()
end

Animator.init = function () 
	if Animator._driver == nil then
		Animator._driver = sys.new_timer(33, Animator._wrapper)        
	end
	Animator.start()
end

-- Stops and clears all queued animations
Animator.reset = function () 
	if Animation._active then 
		Animator._active = false
		if true then
			for i,animator in pairs(Animator._animations) do
				gc = true
				if animator then
					animator:finish()
				end
				Animator._animations[i] = nil
			end
		else 
			Animator._animations = {}
		end
	end
end

-- Returns the average frametime for all animations
Animator.getTimebase = function () 
	return 1000.0/20 --Animator._smoothedFps
end

Animator.setFramerateUpdateCallback = function (cb)
	Animator._frameRateCb = cb 
end

-- Process all animations in the queue
Animator.process = function ()
	if Animator._stableFramerate then
		local activeTrans = 0
		local gc = false
		local currentTimebase = Animator.getTimebase()
		for i,animator in pairs(Animator._animations) do
			gc = true
			if animator then
				activeTrans = activeTrans + 1
				local res = animator:update(currentTimebase)
				if res then
					activeTrans = activeTrans - 1
					Animator._animations[i] = nil
				end
			end
		end

		-- Trigger a garbage collect when all animations in the queue been run
		if gc and activeTrans == 0 then
			print(collectgarbage("count"))
	--		onTimer = function () end 
			collectgarbage("collect")
		elseif activeTrans == 0 then
			Animator.stop()
		else 
		end
	end
end

