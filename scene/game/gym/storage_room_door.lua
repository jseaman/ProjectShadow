-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onDoorTouch()
	if not game.events.isTriggered("basketball_court.storage_door_unlocked") then
		scene:playSound("locked")
		game.hud.showInfoCaption(i18n._"Gym.StorageDoor.Locked")
	else
		game.scenes.gotoGameScene("game.gym.storage_room")
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/basketball_court/utilityroom_door_zoom.jpg"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(79), device.y(0), 414, 360, onDoorTouch))
	
	self:addToScene(game.ui.newItemRegion(device.x(405), device.y(221), 48, 50, {
		itemName = "StorageKey",
		onCorrectItem = { text = i18n._"Gym.StorageDoor.Unlocked", event = "basketball_court.storage_door_unlocked", handler = function()
			scene:playSound("unlocked")
		end},
		onNoItem = i18n._"Gym.StorageDoor.KeyHole",
	}))	
	
	self:addToHUD(game.ui.newBackButton("game.gym.basketball_court"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("locked", "assets/sounds/game/gym/locker_locked.mp3")
		self:loadSound("unlocked", "assets/sounds/game/gym/locker_unlock.mp3")
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