-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:createRoundCrest()
	self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/man_medal.png", device.x(182), device.y(146), 49, 49))
	
	local eyes = self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/man_glow.png", device.x(190), device.y(154), 33, 22))
	if not game.events.isTriggered("gym.storage_room_chest.round_placed") then
		eyes.alpha = 0
		scene:newTransition(eyes, { alpha = 1, time = 500 })
		scene:newTimer(500, function()
			scene:newTransition(scene.roundLock, { alpha = 0, time = 500 })
			scene:playSound("lock_off")
		end)
	end
end

-----------------------------------------------------------------------------------------

function scene:createHexCrest()
	self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/lion_medal.png", device.x(259), device.y(144), 47, 54))
	
	local eyes = self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/lion_glow.png", device.x(267), device.y(155), 33, 22))
	if not game.events.isTriggered("gym.storage_room_chest.hex_placed") then
		eyes.alpha = 0
		scene:newTransition(eyes, { alpha = 1, time = 500 })
		scene:newTimer(500, function()
			scene:newTransition(scene.hexLock, { alpha = 0, time = 500 })
			scene:playSound("lock_off")
		end)
	end
end

-----------------------------------------------------------------------------------------

function scene:createSquareCrest()
	self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/skull_medal.png", device.x(335), device.y(147), 43, 43))
	
	local eyes = self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/skull_glow.png", device.x(337), device.y(152), 39, 26))
	if not game.events.isTriggered("gym.storage_room_chest.square_placed") then
		eyes.alpha = 0
		scene:newTransition(eyes, { alpha = 1, time = 500 })
		scene:newTimer(500, function()
			scene:newTransition(scene.squareLock, { alpha = 0, time = 500 })
			scene:playSound("lock_off")
		end)
	end
end

-----------------------------------------------------------------------------------------

function scene:checkChestLock()
	scene:newTimer(1400, function()
		if game.events.isTriggered("gym.storage_room_chest.round_placed")
			and game.events.isTriggered("gym.storage_room_chest.hex_placed")
			and game.events.isTriggered("gym.storage_room_chest.square_placed") then
			game.events.trigger("gym.storage_room.chest_open")
			scene:playSound("chest_open")
			game.scenes.gotoGameScene("game.gym.storage_room_chest_open")
		end
	end)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/storage_room/chest/chest_closed_zoom.jpg"))
	
	if not game.events.isTriggered("gym.storage_room_chest.round_placed") then
		self.roundLock = self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/man_lock.png", device.x(244), device.y(224), 24, 27))
		self:addToScene(game.ui.newItemRegion(device.x(182), device.y(146), 49, 49, {
			itemName = "ChestRoundCrest",
			onCorrectItem = { text = i18n._"Gym.StorageRoomChest.RoundPlaced", event = "gym.storage_room_chest.round_placed", handler = function()
				scene:createRoundCrest()
				scene:playSound("crest")
				scene:checkChestLock()	
			end},
			onNoItem = i18n._"Gym.StorageRoomChest.NoRoundCrest",
		}))
	else
		self:createRoundCrest()
	end
	
	if not game.events.isTriggered("gym.storage_room_chest.hex_placed") then
		self.hexLock = self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/lion_lock.png", device.x(269), device.y(219), 17, 28))
		self:addToScene(game.ui.newItemRegion(device.x(259), device.y(144), 47, 54, {
			itemName = "ChestHexCrest",
			onCorrectItem = { text = i18n._"Gym.StorageRoomChest.HexPlaced", event = "gym.storage_room_chest.hex_placed", handler = function()
				scene:createHexCrest()
				scene:playSound("crest")
				scene:checkChestLock()					
			end},
			onNoItem = i18n._"Gym.StorageRoomChest.NoHexCrest",
		}))
	else
		self:createHexCrest()
	end
	
	if not game.events.isTriggered("gym.storage_room_chest.square_placed") then
		self.squareLock = self:addToScene(game.ui.newImage("assets/images/game/gym/storage_room/chest/skull_lock.png", device.x(290), device.y(222), 23, 29))
		self:addToScene(game.ui.newItemRegion(device.x(335), device.y(147), 43, 43, {
			itemName = "ChestSquareCrest",
			onCorrectItem = { text = i18n._"Gym.StorageRoomChest.SquarePlaced", event = "gym.storage_room_chest.square_placed", handler = function()
				scene:createSquareCrest()
				scene:playSound("crest")
				scene:checkChestLock()	
			end},
			onNoItem = i18n._"Gym.StorageRoomChest.NoSquareCrest",
		}))
	else
		self:createSquareCrest()
	end
	
	self:addToScene(game.ui.newBackButton("game.gym.storage_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("crest", "assets/sounds/game/gym/crest.mp3")
		self:loadSound("chest_open", "assets/sounds/game/gym/chest_open.mp3") --TODO: get better sound
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