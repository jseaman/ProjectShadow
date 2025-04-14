-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onWillTouch()
	if game.inventory.hasSelectedItem("Robot") then
		if not game.events.isTriggered("gave_robot_back_to_will") then
			game.hud.showCaptionAndTrigger("gave_robot_back_to_will", { who = "will", text = i18n._"Gym.BoysToilets.Will.Robot", filterTouch = true, callback = function()
				game.journal.recordEntry("Gym.MirandaLock")
			end})
		else
			game.hud.showCaption({ who = "will", text = i18n._"Gym.BoysToilets.Will.RobotAgain" })
		end
	elseif game.inventory.hasSelection() then
		game.hud.showCaption({ who = "will", text = i18n._"Gym.BoysToilets.Will.WrongItemRobot" })	
	else
		game.hud.showRandomCaption({ who = "will", text = i18n._"Gym.BoysToilets.Will" })
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_bathroom/bathroom.jpg"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(301), device.y(50), 166, 227, "game.gym.boys_sink"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(50), device.y(20), 125, 300, "game.gym.boys_toilets"))
	
	if game.events.isTriggered("gym.sink.hidden_message") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_bathroom/sink/steam_message_panorama.png", device.x(386), device.y(79), 22, 116))
	else
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_bathroom/sink/hidden_message_panorama.png", device.x(388), device.y(177), 17, 11))
	end
	
	if game.events.isTriggered("will.toilet") then
		if game.events.isTriggered("will.toilet.out") and not game.puzzles.hasFinished("boys_showers_tiles") then
			local will = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_locker_room/will.png", device.x(175), device.y(91), 183, 270, onWillTouch))
			will.alpha = 0.8
		end	
	end
	
	self:addToScene(game.ui.newBackButton(function()
		game.scenes.gotoGameSceneDoor("game.gym.boys_hallway", "bath")
	end))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		if game.events.isTriggered("will.toilet.out") and not game.events.isTriggered("will.toilet.out.stall") then
			scene:loadSound("stall_door", "assets/sounds/game/gym/metal2.mp3")
			scene:playSound("stall_door")
			game.events.trigger("will.toilet.out.stall")
		end
	elseif event.phase == "did" then
		game.hud.show()
		
		if game.events.isTriggered("will.toilet") and not game.events.isTriggered("will.toilet.out") and not game.events.isTriggered("will.toilet.ask_help") then
			game.hud.showCaptionAndTrigger("will.toilet.ask_help", { who = "will", text = i18n._"Gym.BoysBathroom.Will.AskHelp" })
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