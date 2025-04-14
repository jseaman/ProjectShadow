-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:showPickUpTutorial()
	scene.pickUpTutorial = scene:addToScene(game.ui.newGroup())
	scene.pickUpTutorial.alpha = 0
	
	game.ui.insertChild(scene.pickUpTutorial, game.ui.newImage("assets/images/game/gym/boys_locker_room/journal/arrow_1.png", 
		device.x(342), device.y(115), 75, 120))
		
	game.ui.insertChild(scene.pickUpTutorial, game.ui.newTextBox({
		set_name="Standard", text=i18n._"Tutorial.PickUpJournal", color={0.54,0.79,0.62}, 
		x = device.x(295), y = device.y(20), size = 30, width = 220, height = 200, align = "center"
	}))
		
	self.pickUpTutorialTransition = scene:newTransition(scene.pickUpTutorial, { alpha = 1, time = 800 })
end

-----------------------------------------------------------------------------------------

function scene:hidePickUpTutorial()
	self.pickUpTutorialTransition = game.ui.cancelTransition(self.pickUpTutorialTransition)
	scene:newTransition(scene.pickUpTutorial, { alpha = 0, time = 500 })
end

-----------------------------------------------------------------------------------------

function scene:showInventoryTutorial()
	scene.inventoryTutorial = scene:addToScene(game.ui.newGroup())
	scene.inventoryTutorial.alpha = 0
	
	game.ui.insertChild(scene.inventoryTutorial, game.ui.newImage("assets/images/game/gym/boys_locker_room/journal/arrow_2.png", 
		game.inventory.getFirstItemLeft() + 5, game.inventory.getItemBarTop() - 76 + 5, 75, 76))
		
	game.ui.insertChild(scene.inventoryTutorial, game.ui.newTextBox({
		set_name="Standard", text=i18n._"Tutorial.OpenJournal", color={0.54,0.79,0.62}, 
		x = game.inventory.getFirstItemLeft() + 65, y = game.inventory.getItemBarTop() - 110, size = 30, width = 220, height = 200, align = "center"
	}))
	
	scene:newTransition(scene.inventoryTutorial, { alpha = 1, delay = 500, time = 800 })
end

-----------------------------------------------------------------------------------------

function scene:hideInventoryTutorial()
	scene:newTransition(scene.inventoryTutorial, { alpha = 0, time = 500 })
end

-----------------------------------------------------------------------------------------

function scene:onInventoryClosing()
	scene:hideInventoryTutorial()
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/journal/bg_lou_journal.jpg"))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/boys_locker_room/journal/journal.jpg", 
		device.x(223), device.y(180), 123, 58, "Journal", function()
			scene:hidePickUpTutorial()
			scene:showHUD()
			scene:showInventoryTutorial()
		end))
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_locker_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		if not game.inventory.hasPickedUpItem("Journal") then
			scene:hideHUD()
		end
	elseif event.phase == "did" then
		game.hud.show()
		
		if not game.inventory.hasPickedUpItem("Journal") then
			scene:showPickUpTutorial()
		end
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