-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:createToiletHandle()
	self.toiletHandle = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_bathroom/toilets/toilet_handle.png", device.x(224), device.y(72), 34, 22, function()
		self:flushToilet()
	end))
	self.toiletHandle.anchorX, self.toiletHandle.anchorY = 0.8, 0.5
	self.isFlushing = false
end

-----------------------------------------------------------------------------------------

function scene:flushToilet()
	if self.isFlushing then
		return
	end	
	self.isFlushing = true
	
	local firstFlush = not game.events.isTriggered("boys_bathroom.toilet_flushed")
	
	self:playSound("handle")
	
	self:newTransition(self.toiletHandle, { rotation = -30, time = 350, onComplete = function()
		if firstFlush then
			game.events.trigger("boys_bathroom.toilet_flushed")
			self:playSound("flush")
		end
		self:newTransition(self.toiletHandle, { rotation = 0, time = 250, transition = easing.outBack, onComplete = function()
			self.isFlushing = false
			if not firstFlush then
				game.hud.showInfoCaption(i18n._"Gym.Toilet.FlushAgain")
			end
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_bathroom/toilets/bg_right_toilet.jpg"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(205), device.y(19), 170, 172, "game.gym.boys_toilet_right_tank"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(205), device.y(209), 170, 119, i18n._"Gym.Toilet.Bowl"))
	
	if not game.events.isTriggered("gym.toilet_handle") then
		self:addToScene(game.ui.newItemRegion(device.x(198), device.y(50), 53, 50, {
			itemName = "ToiletHandle",
			onCorrectItem = { text = i18n._"Gym.Toilet.MissingHandlePlaced", event = "gym.toilet_handle", handler = function()
				scene:createToiletHandle()
			end},
			onNoItem = i18n._"Gym.Toilet.MissingHandle",
		}))
	else
		self:createToiletHandle()
	end	
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_toilets"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("handle", "assets/sounds/game/gym/toilet_handle.mp3")
		self:loadSound("flush", "assets/sounds/game/gym/toilet_flush.mp3")
	elseif event.phase == "did" then
		game.hud.show()
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