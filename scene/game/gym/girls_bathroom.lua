-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onToiletPaperTaken()
	game.stage.play(game.stage.footstepsSound)
	scene:newTimer(1500, function()
		game.hud.showMyCaption(i18n._"Gym.GirlsBathroom.Footsteps", function()
			game.events.trigger("girls_hallway.miranda_returned")
			game.scenes.gotoGameScene("game.gym.girls_hallway")
		end)
	end)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/girls_bathroom/girls_bathroom.jpg"))
		
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/girls_bathroom/toilet_paper.png", 
		device.x(180), device.y(240), 21, 32, "ToiletPaper", onToiletPaperTaken))
		
	self:addToScene(game.ui.newBackButton(function()
		game.scenes.gotoGameSceneDoor("game.gym.girls_hallway", "bath")
	end))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
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