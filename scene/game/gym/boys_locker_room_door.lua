-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:startAnimation()
	self:newTransition(self.playerHand, { y = device.y(140), x = device.x(349), time = 2500, transition = easing.outQuad, onComplete=function()
		--self:newTransition(self.playerHand, { y = display.contentHeight-210, time = 300 })
	end})
	self:newTimer(850, function()
		self:playSound("shriek1")
		
		self:newTimer(250, function()
			self.shakeEffect = game.effects.newShakeEffect({
				group = self.sceneLayer,
				amount = 50,
				intensity = 3
			})
			self.shakeEffect:start()
			system.vibrate()
		end)
		
		self:newTimer(3000, function()
			self:showMyCaptionAndTrigger("boys_locker_room.scare1_shriek1", i18n._"Lou.WhatWasThat?", function()
				game.scenes.gotoGameScene("game.gym.shade_coming")
			end)
		end)
	end)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	if game.state.get("boys_locker_room_door", "pool") == "pool" then
		self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/door/zoom_door.jpg"))
	else
		self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/door/zoom_door_white.jpg"))
	end
	
	self.playerHand = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/door/hand.png", device.x(462), device.y(242), 186, 221))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("shriek1", "assets/sounds/game/gym/shade_shriek2.mp3")
	elseif event.phase == "did" then
		game.hud.hide()
		self:startAnimation()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene