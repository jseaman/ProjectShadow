-----------------------------------------------------------------------------------------

local game = require("api.game")
local widget = require("widget")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

local imgParts
local selectedImage = -1

local imageLimit = 5

--------------------------------------------------------------------------------------------------

local function ensureImagePositionLimits(image)
	if image.x < imageLimit then
		image.x = imageLimit
	elseif image.x > (display.contentWidth - imageLimit) then
		image.x = display.contentWidth - imageLimit
	end
	
	if image.y < imageLimit then
		image.y = imageLimit
	elseif image.y > (display.contentHeight - imageLimit) then
		image.y = display.contentHeight - imageLimit
	end
end

-----------------------------------------------------------------------------------------

local function onImageTap(event)
	local target = event.target
	local targetId = target.idp
	local result = false
	
	
	
	if target.isonplace == false and (selectedImage == -1 or targetId == selectedImage or event.phase == "began") then
		if event.phase == "began" then
			
			selectedImage = targetId
			target.markX = target.x  
			target.markY = target.y 
			target:toFront()
			result = true
		elseif event.phase == "moved" and selectedImage ~= -1 then
			
			if target.markX ~= nil and target.markY ~= nil then
				
				target.x = (event.x - event.xStart) + target.markX
				target.y = (event.y - event.yStart) + target.markY
				ensureImagePositionLimits(target)
			end
			result = true
		elseif event.phase == "ended" then
			if selectedImage ~= -1 then
				if math.abs(target.x - target.markX) < 2 and math.abs(target.y - target.markY) < 2 then
					target.x = target.markX
					target.y = target.markY
					target.angle = target.angle + 90
					scene.imageTransition = transition.to(target, { time = 100, rotation = target.angle })
				else
					scene:checkValues(target)
				end
				print( target.name .."- x:" .. target.x .. ", y: " .. target.y )
				target.markX = target.x 
				target.markY = target.y
			end
			result = true
		end
		--background:toBack()
	end
	
	return result
end

--------------------------------------------------------------------------------------------------

function scene:checkValues(img)
	--local solution = solutions[img.idp]
	if img.angle % 360 == 0 and img.x < (img.sol.x + 30) and img.x > (img.sol.x - 30) and img.y < (img.sol.y + 30) and img.y > (img.sol.y - 30) then
		img.x, img.y = img.sol.x , img.sol.y
		img.isEnabled = false
		img.isonplace = true
		--img:toBack();
		img:setFillColor(0.5, 0.5, 0.5, 1)
		img:toBack()
		--
		--self:placePartInSolution(img)
		--[[
		if self:isEveryPartSolved() then
			stage.play(stage.loadSound("assets/sounds/game/success.mp3"))
			
			puzzles.finish("ray_office.letter")
			
			instructions.close()
			instructions.remove()
			
			local letter = display.newImageRect("assets/images/game/office/ray_office/letter/legal_department_note.png", 288, 323)
			letter.anchorX, letter.anchorY = 0.5, 0.5
			letter.x, letter.y = display.contentWidth	/ 2, display.contentHeight / 2
			letter.alpha = 0
			self:addToScene(letter)

			self.letterTransition = transition.dissolve(outline, letter, 2000, 500)
		end
		]]
	end
end

--------------------------------------------------------------------------------------------------

function scene:placePartInSolution(img)
	local solution = solutions[img.idp]
	if solution then
		--game.state.ray_office_letter = game.state.ray_office_letter or {}
		--game.state.ray_office_letter[img.idp] = true
		--game.markAsChanged()
		
		img.x, img.y = solution.x , solution.y
		img.isEnabled = false
		img.isonplace = true
		img:toBack();
		img:setFillColor(0.5, 0.5, 0.5, 1)
		--background:toBack()
	end
end


-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	--self:addToScene(game.ui.newBackground("assets/images/template/background.jpg"))
	--[[	
	self:addToScene(game.ui.newTouchAndGo(
		device.x(160), device.y(170), 400, 250, "game.rivals.office_closer"
	))
	]]--
	--self:addToHUD(game.ui.newBackButton("game.rivals.door"))
		
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
		--local img =  self:addToScene(game.ui.newSceneObject("assets/images/puzzles/demo/brazil-01.png", 100, 100, 128, 128, onImageTap))
		
		for i=1,6 do
			local imgName = "";
			if (i == 1) then
				imgName = "usa"
			elseif (i==2) then
				imgName = "mexico"
			elseif (i==3) then
				imgName = "ca"
			elseif (i==4) then
				imgName = "brazil"
			elseif (i==5) then
				imgName = "saa"
			elseif (i==6) then
				imgName = "sab"
			end
			
			
			local img =  self:addToScene(display.newImageRect("assets/images/game/puzzles/demo/world/"..imgName.."-01.png", 128, 128 ))
			
			if (i == 1) then
				img.sol = {x= 209 , y= 113}
			elseif (i==2) then
				img.sol = {x= 199 , y= 140}
			elseif (i==3) then
				img.sol = {x= 226 , y= 160}
			elseif (i==4) then
				img.sol = {x= 274 , y= 207}
			elseif (i==5) then
				img.sol = {x= 256 , y= 191}
			elseif (i==6) then
				img.sol = {x= 260 , y= 251}
			end
			
			img.name = imgName;
			
			img.id = "part0"
			img.idp = 0
			img.angle = 0;
			--img.markX = 0
			--img.markY = 0
		
			local mask = graphics.newMask("assets/images/game/puzzles/demo/world/masks/"..imgName.."-01.png")
			img:setMask(mask)

			img.isHitTestMasked = true
		
			img.x = math.random( imageLimit * 2, display.contentWidth - imageLimit * 2 );
			img.y = math.random( imageLimit * 2 , display.contentHeight - imageLimit * 2);
			
			img.isonplace = false
			img:addEventListener( "touch", onImageTap )
			
		end
		
		
	elseif event.phase == "did" then
		game.hud.show()
	
		if not game.events.isTriggered("rivals.arthur_greet") then
			game.events.trigger("rivals.arthur_greet")
			game.hud.showCaption({
				text = i18n._"TemplateCaption", filterTouch = true
			})
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