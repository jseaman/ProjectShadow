-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onExitTouch(event)
	if game.events.isTriggered("locker_lou.try2") and not game.puzzles.hasFinished("locker_lou_lock") then
		return
	end
	
	if game.puzzles.hasFinished("locker_lou_lock") then
		scene:playSound("open")
		game.scenes.gotoGameScene("game.gym.boys_locker_room")
	elseif not game.events.isTriggered("locker_lou.try1") then
		scene:playSound("locked")
		scene:triggerEvent("locker_lou.try1")
		scene:newTimer(600, function()
			game.hud.showMyCaption(i18n._"LockerLou.How?")
		end)
	elseif not game.events.isTriggered("locker_lou.try2") then
		scene:playSound("hit")
		scene:triggerEvent("locker_lou.try2")
	end
end

-----------------------------------------------------------------------------------------

function scene:refreshState()
	if not game.events.isTriggered("locker_lou.line1") then
		self:showMyCaptionAndTrigger("locker_lou.line1", i18n._"LockerLou.Line1")
	elseif game.events.isTriggered("locker_lou.try2") then
		if not game.events.isTriggered("locker_lou.footsteps") then
			scene:newTimer(1200, function()
				game.stage.play(game.stage.footstepsSound)
			end)
			scene:newTimer(2200, function()
				scene:triggerEvent("locker_lou.footsteps")
			end)
		elseif not game.events.isTriggered("locker_lou.help!") then
			scene:showMyCaptionAndTrigger("locker_lou.help!", i18n._"LockerLou.Help!")
		elseif not game.events.isTriggered("locker_lou.will_appears") then
			self:newTransition(self.characterWill, {time=1000, x=device.x(213), onComplete=function()
				scene:triggerEvent("locker_lou.will_appears")
			end})
		elseif not game.events.isTriggered("locker_lou.will") then
			game.hud.showCaptionChain({ who = "will", text = i18n._"LockerLou.Will", callback = function()
				scene:triggerEvent("locker_lou.will")
				game.scenes.gotoGameScene("game.puzzles.gym.locker_lou_lock")
			end})
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_bg.jpg", device.x(131), device.y(0), 570, 360))
	
	self.characterWill = self:addToScene(game.ui.newSceneObject("assets/images/game/gym/boys_locker_room/will.png", device.x(325), device.y(98), 183, 270))
	
	if game.events.isTriggered("locker_lou.will_appears") then
		self.characterWill.x = device.x(213)
	end
	
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_left_wall.jpg", device.x(0), device.y(0), 128, 360))
	
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_right_wall.jpg", device.x(441), device.y(0), 130, 360))
	
	self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_locker_room/inside/locker_closed_door.png", device.x(129), device.y(0), 313, 360, onExitTouch))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("locked", "assets/sounds/game/gym/locker_locked.mp3")
		self:loadSound("hit", "assets/sounds/game/gym/locker_hit.mp3")
		self:loadSound("open", "assets/sounds/game/gym/locker_close.mp3")
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