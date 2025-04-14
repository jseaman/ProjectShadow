-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onMiddleToiletTouch()
	if game.events.isTriggered("will.toilet") and not game.events.isTriggered("will.toilet.out") then
		if game.inventory.hasSelectedItem("ToiletPaper") then
			game.inventory.discard("ToiletPaper")
			game.inventory.close()
			game.hud.showCaptionAndTrigger("will.toilet.out", { who = "will", text = i18n._"Gym.BoysToilets.Will.ThanksForPaper", filterTouch = true, callback = function()
				scene:playSound("toilet_flush")
				game.achievements.unlock("help_will")
				scene:newTimer(1500, function()					
					game.scenes.gotoGameScene("game.gym.boys_bathroom", "fade", 3000)
				end)
			end})
		elseif game.inventory.hasSelection() and game.events.isTriggered("will.toilet.explained") then
			game.hud.showCaption({ who = "will", text = i18n._"Gym.BoysToilets.Will.WrongItemPaper" })
		elseif not game.events.isTriggered("will.toilet.explained") then
			game.hud.showCaption({ who = "will", text = i18n._"Gym.BoysToilets.Will.Stuck1", filterTouch = true })
			game.events.trigger("will.toilet.explained")
			game.events.trigger("girls_hallway.miranda_left1")
		else
			game.hud.showRandomCaption({ who = "will", text = i18n._"Gym.BoysToilets.Will.Stuck2" })
		end
	else
		game.scenes.gotoGameScene("game.gym.boys_toilet_middle")
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_bathroom/toilets/toilets_doors.jpg"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(31), device.y(20), 129, 274, "game.gym.boys_toilet_left"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(194), device.y(21), 180, 273, onMiddleToiletTouch))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(407), device.y(21), 133, 273, "game.gym.boys_toilet_right"))
	
	if game.events.isTriggered("will.toilet") then
		if not game.events.isTriggered("will.toilet.out") then
			self:addToScene(game.ui.newImage("assets/images/game/gym/boys_bathroom/toilets/will_shoes.png", device.x(250), device.y(282), 71, 28))
		end	
	end
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_bathroom"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("toilet_flush", "assets/sounds/game/gym/toilet_flush.mp3")
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