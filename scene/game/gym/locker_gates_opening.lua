-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function openLocker()
	game.events.trigger("gates_locker_unlocked")
	scene:playSound("locker_unlock")
	scene:newTimer(1000, function()
		scene:playSound("locker_open")
		scene.lockerOpen.isVisible = true
		game.achievements.unlock("open_portal")
		scene:newTimer(4000, function()
			game.scenes.gotoGameScene("game.gym.boys_showers")
		end)
	end)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/gates/gates_locker_zoom.jpg"))
	
	self.lockerOpen = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/gates/gates_locker_opened_zoom.jpg", device.x(181), device.y(0), 389, 360))
	self.lockerOpen.isVisible = false
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("locker_unlock", "assets/sounds/game/gym/locker_unlock.mp3")
		self:loadSound("locker_open", "assets/sounds/game/gym/locker_open.mp3")
	elseif event.phase == "did" then
		game.hud.hide()
		scene:newTimer(1000, openLocker)
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
	elseif event.phase == "did" then
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene