-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:animateGlow(glow, times)
	times = times or math.random(2,5)
	if times <= 0 then
		scene:startNextGlow(glow)
		return
	end
	
	glow.alpha = 0
	
	scene:newTransition(glow, { alpha = 1, delay = math.random(20, 60), time = math.random(60, 120), onComplete = function()
		scene:newTransition(glow, { alpha = 0, delay = math.random(20, 60), time = math.random(60, 120), onComplete = function()
			scene:animateGlow(glow, times - 1)
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:startNextGlow(glow)
	glow.alpha = 0
	scene:newTimer(math.random(1000, 10000), function()
		scene:animateGlow(glow)
	end)
end

-----------------------------------------------------------------------------------------

function scene:startVending()
	scene:playSound("coin")
	scene:newTimer(1800, function()
		scene:playSound("spiral")
		scene:newTransition(scene.spiral, { rotation = 360, time = 1000, onComplete = function()
			scene:playSound("chips")
			scene:newTransition(scene.bagInside, { y = device.y(280), time = 300, onComplete = function()
				scene:createBagOutside()
			end})
		end})
	end)
end

-----------------------------------------------------------------------------------------

function scene:createBagOutside()
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/vending_machine/porkitos_bag_out.png", 
		device.x(205), device.y(305), 41, 23, "Chips"))
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/vending_machine/vending_machine.jpg"))
	
	self.tastyGlow = self:addToScene(game.ui.newImage("assets/images/game/gym/vending_machine/tasty_glow.png", device.x(184), device.y(127), 200, 101))
	
	if not game.events.isTriggered("gym.vending_coin_placed") then
		self.spiral = self:addToScene(game.ui.newImage("assets/images/game/gym/vending_machine/spiral.png", 
			device.x(195 + 52/2), device.y(185 + 49/2), 52, 49))
		self.spiral.anchorX, self.spiral.anchorY = 0.5, 0.5 
		
		local InsideMaskX = 185
		local InsideMaskY = 181
		self.insideContainer = self:addToScene(display.newGroup())
		self.insideContainer:setMask(graphics.newMask("assets/images/game/gym/vending_machine/mask_1.png"))
		self.insideContainer.maskX, self.insideContainer.maskY = device.x(InsideMaskX + 80/2), device.y(InsideMaskY+142/2)
		
		self.bagInside = game.ui.insertChild(self.insideContainer, game.ui.newImage("assets/images/game/gym/vending_machine/porkitos_bag_inside.png", 
			device.x(205), device.y(186), 33, 46))
		
		self:addToScene(game.ui.newImage("assets/images/game/gym/vending_machine/glass.png", device.x(184), device.y(128), 200, 141))
		
		self:addToScene(game.ui.newItemRegion(device.x(337), device.y(255), 50, 50, {
			itemName = "Coin",
			onCorrectItem = { text = i18n._"Gym.VendingMachine.CoinPlaced", event = "gym.vending_coin_placed", handler = function()
				scene:startVending()
			end},
			onNoItem = i18n._"Gym.VendingMachine.CoinNeeded",
		}))
	else
		scene:createBagOutside()
	end
	
	self.signGlow = self:addToScene(game.ui.newImage("assets/images/game/gym/vending_machine/sign_glow.jpg", device.x(0), device.y(0), 570, 124))
	
	self:addToScene(game.ui.newTouchMyCaption(device.x(0), device.y(0), 570, 124, i18n._"Gym.VendingMachine.Porkitos"))
	
	self:addToHUD(game.ui.newBackButton("game.gym.pool"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene.crankHandleMoving = false
		scene:loadSound("coin", "assets/sounds/game/gym/coin.mp3")
		scene:loadSound("spiral", "assets/sounds/game/gym/vending_spiral.mp3")
		scene:loadSound("chips", "assets/sounds/game/gym/chips_out.mp3")
	elseif event.phase == "did" then
		game.hud.show()
		scene:startNextGlow(scene.signGlow)
		scene:startNextGlow(scene.tastyGlow)
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then		
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene