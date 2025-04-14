-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local photos = {
  "assets/images/game/gym/principal_den/portrait_puzzle/bg_portrait_puzzle.jpg",
  "assets/images/game/gym/boys_bathroom/toilets/bg_middle_toilet.jpg",
  "assets/images/game/intro/dream_miranda.jpg",
  "assets/images/game/gym/basketball_court/basket_book_zoom.jpg",
  "assets/images/game/gym/boys_locker_room/dexter/dexter_puzzle_zoom.jpg",
  "assets/images/game/gym/boys_locker_room/bg_lockers.jpg",
  "assets/images/game/intro/dream_will.jpg",
}

-----------------------------------------------------------------------------------------

function scene:showPhoto(index)
  if index > #scene.photos then    
    game.scenes.gotoGameScene("game.intro.12_whoami", "fade", 200)
    return
  end
  
  game.stage.playBackSound()
  scene.photos[index].isVisible = true
  
  scene:newTimer(150, function()
    scene:showPhoto(index + 1)
  end)
end

function scene:startPhotos()
  scene:showPhoto(1)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self.photos = {}
  for photo in list_iter(photos) do
    local image = self:addToScene(game.ui.newBackground(photo))
    image.fill.effect = "filter.exposure"
    image.fill.effect.exposure = 1.2
    image.isVisible = false
    
    table.insert(self.photos, image)
  end
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