-----------------------------------------------------------------------------------------

local game = require("api.game")
local widget = require("widget")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local lock
local leftArrow
local rightArrow
local errorImage

-----------------------------------------------------------------------------------------

local solutions = {75, 20, 85, 50}
local WrongWayThreshold = 20
local DirectionLeft = 0
local DirectionRight = 1
local MinErrorToSkip = 8

-----------------------------------------------------------------------------------------

local initialAngle = 0
local currentNumber = 0
local currentStep = 1
local wrongWayDistance = 0
local direction = DirectionLeft
local moving = false

--------------------------------------------------------------------------------------------------

local function showCurrentArrow()
	local arrow = (direction == DirectionLeft and leftArrow) or rightArrow
	local otherArrow = (direction == DirectionLeft and rightArrow) or leftArrow

	if arrow.alpha ~= 0.8 then
		scene:newTransition(arrow, {time=500, alpha=0.8})
	end
	if otherArrow.alpha ~= 0 then
		scene:newTransition(otherArrow, {time=300, alpha=0})
	end
end

local function resetLock()
	currentStep = 1
	direction = DirectionLeft
	wrongWayDistance = 0
	showCurrentArrow()
end

local function finishPuzzle()
	game.puzzles.finish("locker_lou_lock")
	leftArrow.isVisible = false
	rightArrow.isVisible = false	
	scene:playSound("locker_open")
	scene:newTimer(2000, function()
		game.scenes.gotoGameScene("game.gym.locker_lou")
	end)
end

local function animateSkipButton()
	local factors = { 1, -1 }
	local factorY = factors[math.random(1, 2)]
	local factorX = factors[math.random(1, 2)]
	
	scene:newTransition(scene.skipButton, { alpha = 1, delay = math.random(50, 80), time = math.random(40, 200), 
		y = scene.skipButton.y + (math.random(1, 3) * factorY), x = scene.skipButton.x - (math.random(1,3) * factorX), 
		transition = easing.outExpo, onComplete = function()
			animateSkipButton()
	end})
end

local function showSkipButton(animate)
	if game.state.get("locker_lou_lock_fail", 0) > MinErrorToSkip and scene.skipButton == nil then
		scene.skipText = scene:addToHUD(game.ui.newTextBox({
			set_name="Standard", text=i18n._"Skip", color={0.54,0.79,0.62}, 
			x = device.x(450), y = device.y(190), size = 20, width = 45, height = 50, align = "center"
		}))
		scene.skipButton = scene:addToHUD(game.ui.newButton(device.x(450), device.y(134), {
			defaultFile = "assets/images/game/puzzles/gym/locker_lou_lock/skip_button.png",
			overFile = "assets/images/game/puzzles/gym/locker_lou_lock/skip_button_over.png",
			width = 45, height = 45, onRelease = function()
				scene:newTransition(scene.skipButton, { alpha = 0, time = 500, transition = easing.outExpo })
				scene:newTransition(scene.skipText, { alpha = 0, time = 500, transition = easing.outExpo })
				if not game.puzzles.hasFinished("locker_lou_lock") then
					game.stage.playBackSound()
					finishPuzzle()
				end
			end
		}))		
		
		if animate then
			scene:playSound("skip")
			scene.skipButton.y = scene.skipButton.y + 10
			scene.skipButton.alpha = 0
			scene:newTransition(scene.skipButton, { alpha = 1, time = 500, y = scene.skipButton.y, transition = easing.outExpo })
		end
		--animateSkipButton()
	end
end

local function showError()
	if not scene.errorTransition then
		game.stage.play(game.stage.errorSound)
		resetLock()
		errorImage.alpha = 1
		errorImage.xScale, errorImage.yScale = 1,1
		scene.errorTransition = scene:newTransition(errorImage, {time=500, xScale=8, yScale=8, alpha=0, onComplete=function()
			scene.errorTransition = nil
		end})
		
		game.state.set("locker_lou_lock_fail", game.state.get("locker_lou_lock_fail", 0) + 1)
		if game.state.get("locker_lou_lock_fail", 0) > MinErrorToSkip then
			showSkipButton(true)
		end
	end
end

local function checkSolution()
	if currentStep > 4 then
		finishPuzzle()
		return true
	end
	return false
end

local function changeDirection()
	direction = (direction == DirectionLeft and DirectionRight) or DirectionLeft
	currentStep = currentStep + 1
	if not checkSolution() then
		showCurrentArrow()
		scene:playSound("lock_good")
	end
end

local function getClosestDistance(number1, number2)
	local dist1 = math.abs(number1 - number2)
	local dist2 = 100 - math.max(number1, number2) + math.min(number1, number2)
	return math.min(dist1, dist2)
end

local function isGoingWrongWay(newNumber)
	local diff = newNumber - currentNumber
	return (direction == DirectionLeft and (newNumber < currentNumber or diff > 40))
		or (direction == DirectionRight and (newNumber > currentNumber or diff < -40))
end

local function onTouch(event)
	if game.puzzles.hasFinished("locker_lou_lock") then
		return
	end

	display.getCurrentStage():setFocus(event.target)

	if event.phase == "began"  then
		initialAngle = math.atan2(event.y - lock.y, event.x - lock.x) * (180 / math.pi)	* -1

		initialAngle = initialAngle % 360
		initialAngle = (initialAngle + lock.rotation) % 360
	elseif event.phase == "moved" then
		moving = true
		local deg = math.atan2(event.y - lock.y, event.x - lock.x) * (180 / math.pi)

		local newRotation = (deg % 360) + initialAngle
		local newNumber = math.round((360 - (newRotation % 360)) / 3.6)

		if newNumber == 100 then
			newNumber = 0
		end

		if currentNumber ~= newNumber then
			scene:playSound("safe_click")
			lock.x = lock.x
			lock.y = lock.y
			lock.anchorChildren = true
			lock.anchorX, lock.anchorY = 0.5, 0.5
			lock.rotation = 360 - (3.6 * newNumber)

			local isWrongWay = isGoingWrongWay(newNumber)
			if isWrongWay then
				wrongWayDistance = wrongWayDistance + getClosestDistance(newNumber, currentNumber)
			else
				wrongWayDistance = 0
			end

			currentNumber = newNumber

			if wrongWayDistance > WrongWayThreshold then
				showError()
				moving = false
				display.getCurrentStage():setFocus(nil)
				return false
			elseif not isWrongWay and getClosestDistance(currentNumber, solutions[currentStep]) < 5 then
				changeDirection()
			end
		end
	elseif event.phase == "ended" or event.phase == "canceled" then
		if moving and not game.puzzles.hasFinished("locker_lou_lock") then
			showError()
		end
		moving = false
		display.getCurrentStage():setFocus(nil)
	end

	return true
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/puzzles/gym/locker_lou_lock/bg_lock.jpg"))

	lock = self:addToScene(game.ui.newImage("assets/images/game/puzzles/gym/locker_lou_lock/numbers.png", device.x(285), device.y(234), 146, 146))
	lock.anchorX, lock.anchorY = 0.5, 0.5
	lock:addEventListener("touch", onTouch)
	lock:addEventListener("tap", onTouch)

	leftArrow = self:addToScene(game.ui.newImage("assets/images/game/puzzles/gym/locker_lou_lock/left_arrow.png", device.x(130), device.y(90), 149, 112))
	leftArrow.alpha = 0
	rightArrow = self:addToScene(game.ui.newImage("assets/images/game/puzzles/gym/locker_lou_lock/right_arrow.png", device.x(291), device.y(90), 149, 112))
	rightArrow.alpha = 0

	errorImage = self:addToScene(game.ui.newImage("assets/images/game/puzzles/gym/locker_lou_lock/error.png", device.x(285), device.y(230), 50, 50))
	errorImage.anchorX, errorImage.anchorY = 0.5, 0.5
	errorImage.alpha = 0

	local mask = graphics.newMask("assets/images/game/puzzles/gym/locker_lou_lock/masklock.png")
	lock:setMask(mask)
	lock.isHitTestMasked = true
	
	scene.skipButton = nil
	showSkipButton()

	currentNumber = 0
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("safe_click", "assets/sounds/game/gym/safe_click.mp3")
		self:loadSound("locker_open", "assets/sounds/game/gym/locker_unlock.mp3")
		self:loadSound("lock_good", "assets/sounds/game/gym/lock_good.mp3")
		self:loadSound("skip", "assets/sounds/game/general/bubble.mp3")
	elseif event.phase == "did" then
		game.hud.show()
		scene.errorTransition = nil
		resetLock()
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
