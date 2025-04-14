-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local BackgroundScale = 1.5

-----------------------------------------------------------------------------------------

function scene:startPanning()
  scene:newTransition(scene.background2, { x = -device.x((570*BackgroundScale - 570)/2), time = 4000, onComplete=function()
		scene.continueText:show()
    game.hud.showMyCaption(i18n._"Intro.WhereAmI", function()
      game.scenes.gotoGameScene("game.intro.09_locker", "fade", 2000)
    end)
  end})
end

function scene:startFlicker()
  scene.background2.isVisible = true
	scene:playSound("static")
  
  scene:newTimer(200, function() 
    scene.background2.isVisible = false
    scene.background2.x = device.x(20)
		--scene:playSound("static")
		
    scene:newTimer(200, function()
      scene.background2.isVisible = true
      scene.background3.isVisible = true
			--scene:playSound("static")
      
      scene:newTimer(100, function()
        scene.background3.isVisible = false
        scene.background2.isVisible = false 
        scene.background2.x = device.x(0)
				--scene:playSound("static")
        
        scene:newTimer(300, function()
          scene.background2.isVisible = true
          scene.background1.isVisible = false
					--scene:playSound("static")
					
					self.hour11am.isVisible = false
					self.hour3am.isVisible = true
					
          scene:newTimer(100, function()						
            scene:startPanning()
          end)
        end)
      end)
    end)
  end)
end

-----------------------------------------------------------------------------------------

function scene:animateCameraDot()
	scene:newTimer(800, function()
		scene.cameraDot.isVisible = not scene.cameraDot.isVisible
	end, 0)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self.background1 = self:addToScene(game.ui.newBackground("assets/images/game/intro/hallway.jpg"))
  self.background1.xScale = BackgroundScale
  self.background1.yScale = BackgroundScale
  
  self.background2 = self:addToScene(game.ui.newBackground("assets/images/game/intro/hallway_dark.jpg"))
  self.background2.xScale = BackgroundScale
  self.background2.yScale = BackgroundScale
  --self.background2.fill.effect = "filter.sobel"
  --self.background2.fill.effect = "filter.woodCut"
  --self.background2.fill.effect.intensity = 0.4
  self.background2.isVisible = false
  
  self.background3 = self:addToScene(game.ui.newBackground("assets/images/game/intro/hallway_dark.jpg"))
  self.background3.xScale = BackgroundScale
  self.background3.yScale = BackgroundScale
  --self.background3.fill.effect = "filter.sobel"
  --self.background2.fill.effect = "filter.woodCut"
  --self.background2.fill.effect.intensity = 0.4
  self.background3.isVisible = false
  self.background3.alpha = 0.5
	
	self.continueText = self:addToHUD(game.ui.newTapToContinueText(true))
	
	self:addToHUD(game.ui.newImage("assets/images/game/intro/rec.png", 0, device.y(19), 85, 26))
	self:addToHUD(game.ui.newImage("assets/images/game/intro/camera_7.png", display.contentWidth - 89, device.y(312), 89, 26))
	self.hour11am = self:addToHUD(game.ui.newImage("assets/images/game/intro/hour_11am.png", display.contentWidth - 85, device.y(19), 85, 26))
	self.hour3am = self:addToHUD(game.ui.newImage("assets/images/game/intro/hour_3am.png", display.contentWidth - 85, device.y(19), 85, 26))
	self.hour3am.isVisible = false
	self.cameraDot = self:addToHUD(game.ui.newImage("assets/images/game/intro/red_dot.png", 34, device.y(31), 9, 9))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene:loadSound("static", "assets/sounds/game/gym/static.mp3")
	elseif event.phase == "did" then
		scene:animateCameraDot()
    self:newTimer(1000, function()
      scene:startFlicker()
    end)
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