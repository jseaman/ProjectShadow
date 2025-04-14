-----------------------------------------------------------------------------------------

local display = require("display")

-----------------------------------------------------------------------------------------

local effects = {}

-----------------------------------------------------------------------------------------

local RainMinAlpha = 0.01
local RainMaxAlpha = 0.5
local RainTime = 150

-----------------------------------------------------------------------------------------

function effects.newRainEffect(options)
	options = options or {}
	options.rain1 = options.rain1 or "assets/images/particle/rain1.png"
	options.rain2 = options.rain2 or "assets/images/particle/rain2.png"
	
	local game = require("api.game")
	local group = display.newGroup()
	group.isVisible = false
	
	local rain1 = game.ui.newBackground(options.rain1)
	rain1.alpha = RainMaxAlpha
	group:insert(rain1)
	
	local rain2 = game.ui.newBackground(options.rain2)
	rain2.alpha = RainMinAlpha
	group:insert(rain2)
	
	local startRain1, startRain2
	
	function startRain1(alphaDest)
		if group.isStarted then
			game.ui.cancelTransition(group.rain1Transition)
			
				group.rain1Transition = transition.to(rain1, { time = RainTime, alpha = alphaDest, onComplete=function()
					group.rain1Transition = nil
					startRain1((alphaDest == RainMinAlpha and RainMaxAlpha) or RainMinAlpha)
			end})
		end
	end
	
	function startRain2(alphaDest)
		if group.isStarted then
			game.ui.cancelTransition(group.rain2Transition)
			
				group.rain2Transition = transition.to(rain2, { time = RainTime, alpha = alphaDest, onComplete=function()
					group.rain2Transition = nil
					startRain2((alphaDest == RainMinAlpha and RainMaxAlpha) or RainMinAlpha)
			end})
		end
	end
	
	function group:show()
		self.isVisible = true
		self.isStarted = true
		
		startRain1(RainMinAlpha)
		startRain2(RainMaxAlpha)
	end
	
	group._base_removeSelf = group.removeSelf
	
	function group:removeSelf()
		self.isStarted = nil
		self.rain1Transition = game.ui.cancelTransition(self.rain1Transition)
		self.rain2Transition = game.ui.cancelTransition(self.rain2Transition)
		
		group:_base_removeSelf()
	end
	
	return group
end

-----------------------------------------------------------------------------------------

function effects.newThunderEffect(options)
	local ui = require("api.ui")
	local stage = require("game.stage")
	options = options or {}
	local audioOnly = options.audioOnly
	local minSeconds = options.minSeconds or 4
	local maxSeconds = options.maxSeconds or 12
	
	local group = display.newGroup()
	group.alpha = 0
	group:insert(ui.newBackground("assets/images/particle/lightning.png"))
	
	local function showThunder(number, alphaTarget)
		if number > 6 then
			group.alpha = 0
			return
		end
			group.thunderTransition = transition.to(group, { alpha = alphaTarget, time = 200, onComplete = function()
				group.thunderTransition = nil
				if alphaTarget < 0.5 then
					alphaTarget = 1
				else
					alphaTarget = 0
				end
				showThunder(number + 1, alphaTarget)
		end})
	end
	
	local function playThunder()
		if group.isStarted and not group.thunderTimer then
			group.thunderTimer = timer.performWithDelay(math.random(minSeconds, maxSeconds) * 1000, function ()
				stage.play(stage.loadSound("assets/sounds/particle/thunder.mp3"), { channel = 5 })
				
				if not audioOnly then
					showThunder(1, 1)
				end
				group.thunderTimer = nil
				playThunder()
			end)
		end
	end
	
	function group:show()
		self.isStarted = true
		playThunder()
	end
	
	group._base_removeSelf = group.removeSelf
	
	function group:removeSelf()
		self.isStarted = nil
		self.thunderTimer = ui.cancelTimer(self.thunderTimer)
		self.thunderTransition = ui.cancelTransition(self.thunderTransition)
		self:_base_removeSelf()
	end
	
	return group
end

-----------------------------------------------------------------------------------------

function effects.newShakeEffect(options)
	local effect = {}
	effect.group = options.group
	effect.amount = options.amount
	effect.intensity = options.intensity or effect.amount
	effect.amountLeft = options.amount
	effect.onComplete = options.onComplete
	effect.originalX = effect.group.x
	effect.originalY = effect.group.y
	
	local function enterFrameHandler()
		if effect.amountLeft > 0 then
			local shake = math.random(effect.intensity)
			effect.group.x = effect.originalX + math.random( -shake, shake )
			effect.group.y = effect.originalY + math.random( -shake, shake )
			effect.amountLeft = effect.amountLeft - 1
		else
			effect:dispose()
			
			if effect.onComplete then
				effect.onComplete()
			end
		end
	end
	
	function effect:start()
		Runtime:addEventListener("enterFrame", enterFrameHandler)
	end
	
	function effect:dispose()
		Runtime:removeEventListener("enterFrame", enterFrameHandler)
		effect.group.x = effect.originalX
		effect.group.y = effect.originalY
		effect.isDisposed = true
		return nil
	end
	
	return effect
end

-----------------------------------------------------------------------------------------

function effects.newWakeUpEffect(options)
	local ui = require("api.ui")
	local group = display.newGroup()
	local blurImage = options.blurImage
	local onComplete = options.onComplete
	local animation
	
	if blurImage then
		--blurImage.fill.effect = "filter.blurVertical"
		--blurImage.fill.effect.blurSize = 100
		--blurImage.fill.effect.sigma = 50
	else
		blurImage = ui.newRectFullScreen({255,255,255})
		blurImage.alpha = 0.9
	end
	
	group:insert(blurImage)
		
	local topLid = ui.insertChild(group, ui.newRect(0, 0, device.contentWidth, device.contentHeight / 2, {0,0,0}))
	local bottomLid = ui.insertChild(group, ui.newRect(0, device.contentHeight / 2, device.contentWidth, device.contentHeight / 2, {0,0,0}))
	
	function group:start()
		local easingMethod = easing.linear
		--self.topTransition = transition.to(topLid, { time = 1700, y = -device.contentHeight/2, transition = easing.inQuart, onComplete=function()
		self.topTransition = transition.to(topLid, { time = 1500, y = -40, transition = easingMethod, onComplete=function()
			self.topTransition = transition.to(topLid, { time = 1000, y = -20, transition = easingMethod, onComplete=function()
				self.topTransition = transition.to(topLid, { time = 2000, y = -device.contentHeight/2, transition = easingMethod, onComplete=function()
					if blurImage then
						self.blurTransition = transition.to(blurImage, { alpha = 0, time = 2000, onComplete=function()
							if onComplete then
								onComplete()
							end
						end})
					else
						if onComplete then
							onComplete()
						end
					end
				end})
			end})
		end})
		
		--self.bottomTransition = transition.to(bottomLid, { time = 2700, y = device.contentHeight, transition = easing.inCirc, onComplete=function()
		self.bottomTransition = transition.to(bottomLid, { time = 1500, y = device.contentHeight / 2 + 40, transition = easingMethod, onComplete=function()
			self.bottomTransition = transition.to(bottomLid, { time = 1000, y = device.contentHeight / 2 + 20, transition = easingMethod, onComplete=function()
				self.bottomTransition = transition.to(bottomLid, { time = 2000, y = device.contentHeight, transition = easingMethod, onComplete=function()
					
				end})
			end})
		end})
	end
	
	group._removeSelf = group.removeSelf
	
	function group:removeSelf()
		if animation then
			animation:stop()
		end
		self.blurTransition = ui.cancelTransition(self.blurTransition)
		self.topTransition = ui.cancelTransition(self.topTransition)
		self.bottomTransition = ui.cancelTransition(self.bottomTransition)
		group:_removeSelf()
		return nil
	end
	
	return group
end


-----------------------------------------------------------------------------------------

function effects.newFullSnapshot()
	local snapshot = display.newSnapshot(device.contentWidth, device.contentHeight)
	snapshot.anchorX, snapshot.anchorY = 0, 0
	snapshot.x, snapshot.y = device.x(0), device.y(0)
	
	function snapshot:addChild(c)
		snapshot.group:insert(c)
		snapshot:invalidate()
		return c
	end
	
	function snapshot:correctX(x)
		return x - snapshot.width / 2
	end
	
	function snapshot:correctY(y)
		return y - snapshot.height / 2
	end
	
	return snapshot
end

-----------------------------------------------------------------------------------------

function effects.newHallucinationEffect()
	local effect = display.newGroup()
	local particles = require("game.particles")
	
	effect:insert(
		particles.createParticle("mental_delusion_spots", "delusionSpots", device.x(290), device.y(200))
	)
	effect:insert(
		particles.createParticle("mental_delusion_clouds", "delusionClouds", device.x(290), device.y(360))
	)
	
	function effect:start()
		particles.startEmitter("delusionSpots")
		particles.startEmitter("delusionClouds")
		
		particles.start()
	end
	
	function effect:dispose()
		particles.cleanUp()
		return nil
	end
	
	return effect
end

-----------------------------------------------------------------------------------------

function effects.newDoorClosesEffect(scene, doors, assetsSubDir)
	local doorName = game.data.comingFromDoor
	if not doorName or not doors[doorName] then
		return nil
	end
		
	local door = doors[doorName]
	local doorImage = scene:addToScene(game.ui.newImage("assets/images/game/gym/black_doors/" .. assetsSubDir .. "/" .. door.filename, 
		device.x(door.x), device.y(door.y), door.w, door.h))
	
	local effect = {}
	
	function effect:start()
		game.data.comingFromDoor = nil
		game.markAsChanged()
		
		scene:newTimer(600, function()
			game.stage.play(game.stage.doorSound)
			game.ui.removeSelf(doorImage)
		end)
	end
	
	return effect
end

-----------------------------------------------------------------------------------------

return effects