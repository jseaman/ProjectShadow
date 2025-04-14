-----------------------------------------------------------------------------------------

local game = require("api.game")
local widget = require("widget")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local rows = 5
local cols = 5
local staticBoxes = { 1, 5, 16, 21, 25 }

-----------------------------------------------------------------------------------------

local imgParts = {}

--------------------------------------------------------------------------------------------------

local function onImageRelease(event)
	local image = event.target
	
	if image.isAnimating or image.isStatic or game.puzzles.hasFinished("water_heater") then
		return
	end
	
	scene:playSound("pipe_touch")
	
	local angle = image.rotation + 90
	scene:saveBoxRotation(image.boxIndex, angle)
	
	image.isAnimating = true	
	image.anchorX, image.anchorY = 0.5, 0.5
	
	scene.imageTransition = scene:newTransition(image, {time=100,rotation=angle, onComplete = function (obj)		
		image.isAnimating = false		
		scene:checkValues()
	end})
end

--------------------------------------------------------------------------------------------------

function scene:checkValues()
	local solved = true
	for i=1,#imgParts do
		if (imgParts[i].rotation % 360) ~= 0 then
			solved = false
			break
		end
	end
	
	if solved then
		game.puzzles.finish("water_heater")
		scene:playSound("pipe_done")
		scene:showSmoke()
	end
end

-----------------------------------------------------------------------------------------

function scene:showSmoke()
	scene:addToScene(game.particles.createStartedParticle("hints_smoke", "smoke", display.contentWidth/2, display.contentHeight/2))
	game.particles.start()
end

-----------------------------------------------------------------------------------------

function scene:isStaticBox(index)
	for i=1,#staticBoxes do
		if staticBoxes[i] == index then
			return true
		end
	end
	
	return false
end

-----------------------------------------------------------------------------------------

function scene:saveBoxRotation(index, rotation)
	game.data.water_heater_boxes = game.data.water_heater_boxes or {}
	game.data.water_heater_boxes[index] = rotation
	game.markAsChanged()
end

-----------------------------------------------------------------------------------------

function scene:getBoxRotation(index)
	game.data.water_heater_boxes = game.data.water_heater_boxes or {}
	local rotation = game.data.water_heater_boxes[index]
	if rotation == nil then
		rotation = math.random(1, 3) * 90
		scene:saveBoxRotation(index, rotation)
	end
	return rotation
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)	
	self:addToScene(game.ui.newBackground("assets/images/game/gym/pool_control_room/pipes/bricks.jpg"))
	
	local buttonSize = {width = 62, height = 62}	
	
	local cont = 1
	for i=0,cols-1 do
		for j=0,rows-1 do
			local image =  self:addToScene(game.ui.newButton( device.x( 126 + (buttonSize.width*j) + (buttonSize.width/2) ),  device.y(26+(buttonSize.height * i)+ buttonSize.height/2), {
				defaultFile = "assets/images/game/gym/pool_control_room/pipes/pipes/pipes_".. cont  .. ".png",
				width = buttonSize.width, height = buttonSize.height, onRelease = onImageRelease
			}))			
			image.anchorX, image.anchorY = 0.5, 0.5
			image.position = cont
			image.isStatic = scene:isStaticBox(cont)
			image.boxIndex = cont
			if not image.isStatic and not game.puzzles.hasFinished("water_heater") then
				image.rotation = scene:getBoxRotation(cont)
			end
			
			imgParts[#imgParts+1]  = image
			
			cont = cont + 1
		end	
	end
	
	self:addToScene(game.ui.newBackground("assets/images/game/gym/pool_control_room/pipes/wall.png"))
	
	self:addToHUD(game.ui.newBackButton("game.gym.pool_control_room"))	
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("pipe_touch", "assets/sounds/game/gym/pipe_touch.mp3")
		self:loadSound("pipe_done", "assets/sounds/game/gym/pipe_done.mp3")
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		game.particles.cleanUp()
	elseif event.phase == "did" then		
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene