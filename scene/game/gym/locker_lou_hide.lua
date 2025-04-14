-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onExitTouch(event)
	if game.events.isTriggered("boys_locker_room.scare1_start") and not game.events.isTriggered("boys_locker_room.scare1_shade_left") then
		game.hud.showMyCaption(i18n._"LockerLou.ShouldStay")
		return
	end
	
	scene:playSound("open")
	game.scenes.gotoGameScene("game.gym.boys_lockers")	
end

-----------------------------------------------------------------------------------------

function scene:refreshState()
	if game.events.isTriggered("boys_locker_room.scare1_start") and not game.events.isTriggered("boys_locker_room.scare1_shade_left") then
		if game.events.isTriggered("boys_locker_room.scare1_shade_appears") then
			self.shadeEnter.alpha = 0.6
			scene:showSmoke()
			scene:startFloatingShade()
		end
			
		if game.events.isTriggered("boys_locker_room.scare1_start") then
			if not game.events.isTriggered("boys_locker_room.scare1_shade_appears") then
				self:newTimer(2000, function()
					self.shadeEnter.alpha = 0
					self.shadeEnter.xScale = 0.5
					self.shadeEnter.yScale = 0.5
					self:playSound("shade")
					scene:startFloatingShade()
					scene:showSmoke()
					self:newTransition(self.shadeEnter, {alpha = 0.6, xScale = 1, yScale = 1, time = 1500, transition = easing.outSine, onComplete=function()
						self:newTimer(2000, function()
							scene:triggerEvent("boys_locker_room.scare1_shade_appears")
						end)
					end})
				end)
			elseif not game.events.isTriggered("boys_locker_room.scare1_shade_moves") then
				self:newTransition(self.shadeEnter, {x = device.x(210), time = 5000, onComplete=function()
					self:newTimer(1000, function()
						self:newTransition(self.shadeEnter, {x = device.x(415), time = 5000, onComplete=function()
							scene:triggerEvent("boys_locker_room.scare1_shade_moves")
						end})
					end)
				end})
			elseif not game.events.isTriggered("boys_locker_room.scare1_shade_left") then
				self:newTransition(self.shadeEnter, {alpha = 0, xScale = 0.5, yScale = 0.5, time = 1500, transition = easing.outSine, onComplete=function()
					self:newTimer(2000, function()
						scene:stopSmoke()
						scene:triggerEvent("boys_locker_room.scare1_shade_left")
						game.events.trigger("boys_locker_room.scare1")
						game.achievements.unlock("hide_from_shade")
						game.stage.playGameMusic("scene.game.gym.locker_lou_hide", 1000)
					end)
				end})
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:startFloatingShade()
	self.floatTransition = game.ui.cancelTransition(self.floatTransition)
	self.floatTransition = self:newTransition(self.shadeEnter, { y = self.shadeEnter.y-3, time = 700, onComplete = function()
		self.floatTransition = self:newTransition(self.shadeEnter, { y = self.shadeEnter.y+3, time = 700, onComplete = function()
			scene:startFloatingShade()
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:showSmoke()
	if not self.smoke then
		self.smoke = game.ui.insertChild(self.roomLayer, game.particles.createStartedParticle("shade_coming_smoke", "smoke", display.contentWidth/2, display.contentHeight/2))
		game.particles.start()
	end
end

function scene:stopSmoke()	
	game.particles.stopEmitter("smoke")
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_bg.jpg", device.x(131), device.y(0), 570, 360))
	
	self.roomLayer = self:addToScene(game.ui.newGroup())
	
	if game.events.isTriggered("boys_locker_room.scare1_start") and not game.events.isTriggered("boys_locker_room.scare1_shade_left") then
		self.shadeEnter = game.ui.insertChild(self.roomLayer, game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/shade_floating.png", device.x(375), device.y(119), 79, 174))
		self.shadeEnter.anchorX, self.shadeEnter.anchorY = 0.5, 0.5
		self.shadeEnter.x, self.shadeEnter.y = device.x(415), device.y(200)
		self.shadeEnter.alpha = 0
	end
	
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_left_wall.jpg", device.x(0), device.y(0), 128, 360))
	
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_right_wall.jpg", device.x(441), device.y(0), 130, 360))
	
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_open_door.png", device.x(129), device.y(0), 272, 360))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(129), device.y(0), 292, 360, onExitTouch))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("open", "assets/sounds/game/gym/locker_close.mp3")
		self:loadSound("shade", "assets/sounds/game/gym/shade_breath.mp3")
		self.smoke = nil
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		game.particles.cleanUp()
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene