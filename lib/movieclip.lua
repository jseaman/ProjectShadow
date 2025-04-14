-------------------------------------------------------------------------

local M = {}

-------------------------------------------------------------------------

function M.newAnimation(images, width, height)
	local g = display.newGroup()
	
	local frames = {}
	for i, frame in ipairs(images) do
		local imageName = frame
		local weight = 1
		if type(imageName) == "table" then
			imageName = frame.name
			weight = frame.weight or 1
		end
		frames[i] = display.newImageRect(imageName, width, height)
		frames[i].isVisible = false
		frames[i].frameWeight = weight
		g:insert(frames[i], true)
	end

	local currentFrame = 1
	local frameCount = #frames
	local startFrame = 1
	local endFrame = #frames
	local loop = 0
	local loopCount = 0
	local remove = false
	local onComplete = nil
	local playing = false
	local frameDuration = 1000
	local frameTimer = nil
		
	local function resetDefaults()
		currentFrame = 1
		startFrame = 1
		endFrame = #frames
		loop = 0
		loopCount = 0
		remove = false
		onComplete = nil
		playing = false
		frameDuration = 1000
		
		if frameTimer then
			timer.cancel(frameTimer)
			frameTimer = nil
		end
	end

	local function nextFrame(self)
		if frames[currentFrame] then
			frames[currentFrame].isVisible = false
		end
		currentFrame = currentFrame + 1
		
		if currentFrame > endFrame then
			if (loop > 0) then
				loopCount = loopCount + 1

				if (loopCount >= loop) then
					g:stop()
				else
					currentFrame = startFrame
				end
			else
				currentFrame = startFrame
			end
		elseif (currentFrame > #frames) then
			currentFrame = 1
		end
		
		if playing then
			frames[currentFrame].isVisible = true
			frameTimer = timer.performWithDelay(frameDuration * frames[currentFrame].frameWeight, function() nextFrame(self) end)
		end
	end
	
	local function getTotalWeight(startFrame, endFrame)
		local weight = 0
		for i = startFrame, endFrame, 1 do
			weight = weight + frames[i].frameWeight
		end
		return weight
	end

	function g:stop()
		if currentFrame > endFrame then
			if onComplete then
				onComplete()
			end
		end
		
		if remove then
			self:removeSelf()
		end
		
		resetDefaults()
	end
	
	function g:play(params)
		g:stop()
		
		if params then
			if (params.startFrame and type(params.startFrame) == "number") then startFrame = params.startFrame end
			if (startFrame > #frames or startFrame < 1) then startFrame = 1 end

			if (params.endFrame and type(params.endFrame) == "number") then endFrame = params.endFrame end
			if (endFrame > #frames or endFrame < 1) then endFrame = #frames end

			if (params.loop and type(params.loop) == "number") then loop = params.loop end
			if (loop < 0) then loop = 0 end

			if (params.remove and type(params.remove) == "boolean") then remove = params.remove end
			
			if (params.time and type(params.time) == "number") then frameDuration = params.time / getTotalWeight(startFrame, endFrame) end
			
			if (params.onComplete and type(params.onComplete) == "function") then onComplete = params.onComplete end
		end
		
		print("Starting animation with frame duration: " .. frameDuration)

		playing = true
		currentFrame = startFrame - 1
		nextFrame(g)
	end

	function g:getCurrentFrame()
		return currentFrame
	end

	function g:getFrameCount()
		return frameCount
	end
	
	return g
end

-------------------------------------------------------------------------

return M

-------------------------------------------------------------------------