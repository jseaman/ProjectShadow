-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local photos = {
 { name = "photo_science.jpg", rotation = -6 },  
 { name = "photo_math.jpg", rotation = 6 },
 { name = "photo_lou.jpg", rotation = -2 },
 { name = "photo_work.jpg", rotation = 6 },
 { name = "photo_quiz.jpg", rotation = -4 }
}

-----------------------------------------------------------------------------------------

function scene:showPhoto(index)
  if index > #scene.photos then
		scene.continueText:show()
    game.hud.showMyCaption(i18n._"Intro.YouGetUsedToIt", function()
      game.scenes.gotoGameScene("game.intro.06_alone", "fade", 2000)
    end)
    return
  end
  
  scene:playSound("book")
  scene.photos[index].isVisible = true
  
  scene:newTimer(800, function()
    scene:showPhoto(index + 1)
  end)
end

function scene:startPhotos()
  scene:showPhoto(1)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self:addToScene(game.ui.newBackground("assets/images/game/intro/bg_table.jpg"))
  
  self.photos = {}
  for photo in list_iter(photos) do
    local image = self:addToScene(game.ui.newImage("assets/images/game/intro/" .. photo.name, device.x(111) + 349/2, device.y(50) + 267/2, 349, 267))
    image.anchorX, image.anchorY = 0.5, 0.5
    image.rotation = photo.rotation
    image.isVisible = false
    
    table.insert(self.photos, image)
  end
	
	self.continueText = self:addToHUD(game.ui.newTapToContinueText(true))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("book", "assets/sounds/game/journal/paper5.mp3")
	elseif event.phase == "did" then
    scene:newTimer(500, function()
      scene:startPhotos()
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