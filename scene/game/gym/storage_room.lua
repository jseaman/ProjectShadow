-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/storage_room/utility_room.jpg"))
	
	scene:addToScene(game.ui.newTouchInfo(device.x(196), device.y(0), 374, 171, i18n._"StorageRoom.Walls"))
	scene:addToScene(game.ui.newTouchInfo(device.x(415), device.y(207), 83, 35, i18n._"StorageRoom.Weights"))
	scene:addToScene(game.ui.newTouchInfo(device.x(396), device.y(255), 174, 93, i18n._"StorageRoom.Mats"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(76), device.y(60), 111, 161, function()
		scene:playSound("cabinet")
		game.scenes.gotoGameScene("game.gym.storage_room_cabinet")
	end))
		
	if game.events.isTriggered("gym.storage_room_chest.round_placed") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/man.png", device.x(275), device.y(193), 12, 12))
	else
		self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/left_lock.png", device.x(292), device.y(211), 5, 7))
	end
	
	if game.events.isTriggered("gym.storage_room_chest.hex_placed") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/lion.png", device.x(293), device.y(193), 12, 13))
	else
		self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/mid_lock.png", device.x(299), device.y(210), 3, 7))
	end
	
	if game.events.isTriggered("gym.storage_room_chest.square_placed") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/skull.png", device.x(310), device.y(194), 12, 11))
	else
		self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/right_lock.png", device.x(304), device.y(211), 4, 7))
	end
	
	local chestScene = "game.gym.storage_room_chest"
	if game.events.isTriggered("gym.storage_room.chest_open") then
		chestScene = "game.gym.storage_room_chest_open"
	end
	self:addToScene(game.ui.newTouchAndGo(device.x(251), device.y(181), 98, 63, chestScene))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/storage_room/valve.png", 
		device.x(455), device.y(262), 30, 16, "WaterHeaterHandle"))
	
	self:addToScene(game.ui.newBackButton(function()
		game.scenes.gotoGameSceneDoor("game.gym.basketball_court", "utility")
	end))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene:loadSound("cabinet", "assets/sounds/game/general/cabinet_open.mp3")
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