-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local BackgroundScale = 1.5

-----------------------------------------------------------------------------------------

function scene:startPanning()
  scene:newTransition(scene.background, { x = -device.x((570*BackgroundScale - 570)/2), time = 4000, onComplete=function()
		scene.continueText:show()
		game.hud.showMyCaption(i18n._"Intro.WhenInSchool", function()
      game.scenes.gotoGameScene("game.intro.05_papers", "fade", 2000)
    end)
  end})
end

-----------------------------------------------------------------------------------------

function scene:animateCameraDot()
	scene:newTimer(800, function()
		scene.cameraDot.isVisible = not scene.cameraDot.isVisible
	end, 0)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self.background = self:addToScene(game.ui.newBackground("assets/images/game/intro/hallway.jpg"))
  self.background.xScale = BackgroundScale
  self.background.yScale = BackgroundScale
	
	self.continueText = self:addToHUD(game.ui.newTapToContinueText(true))
	
	self:addToHUD(game.ui.newImage("assets/images/game/intro/rec.png", 0, device.y(19), 85, 26))
	self:addToHUD(game.ui.newImage("assets/images/game/intro/camera_7.png", display.contentWidth - 89, device.y(312), 89, 26))
	self:addToHUD(game.ui.newImage("assets/images/game/intro/hour_11am.png", display.contentWidth - 85, device.y(19), 85, 26))
	self.cameraDot = self:addToHUD(game.ui.newImage("assets/images/game/intro/red_dot.png", 34, device.y(31), 9, 9))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("talking", "assets/sounds/game/intro/talking.mp3")
	elseif event.phase == "did" then
    self:playSound("talking")
		scene:animateCameraDot()
    self:newTimer(1000, function()
      scene:startPanning()
    end)
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