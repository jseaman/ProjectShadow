-----------------------------------------------------------------------------------------

local game = require("api.game")
local widget = require("widget")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

local rows = 3
local cols = 3

local imgParts = {}
local selectedImage 

local isAnimating = false

--------------------------------------------------------------------------------------------------

local function onImageRelease(event)
	if isAnimating == false then
		
		local target = event.target
	
		if (selectedImage == nil) then
			selectedImage = target
			
			selectedImage:setFillColor( 34/255, 140/255, 35/255, 1)
			
		else
			
			selectedImage:setFillColor(1)
			
			isAnimating = true
			
			local prevPos = {x = target.x, y = target.y}
		
			scene.anim1 = transition.moveTo( target, { x=selectedImage.x, y=selectedImage.y, time=500 } )
			scene.anim2 =transition.moveTo( selectedImage, { x=prevPos.x, y=prevPos.y, time=500 , 
				onComplete = function()
					isAnimating = false
				end 
				})
	
		
			selectedImage = nil
		end
	end
	
end

--------------------------------------------------------------------------------------------------

function scene:checkValues(img)
	
end

--------------------------------------------------------------------------------------------------

function scene:placePartInSolution(img)
	
end


-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
		
		local buttonSize = {width = 60, height = 60}
		
		local center =  { x = device.contentWidth/2 - (cols * buttonSize.width)/2, y = device.contentHeight/2 - (cols * buttonSize.height)/2 }
		
		for i=0,cols-1 do
			for j=0,rows-1 do
				imgParts[#imgParts+1] =  self:addToScene(game.ui.newButton( center.x + (buttonSize.width*i),  center.y + (buttonSize.height * j)- buttonSize.height/2, {
					label = i+(j*3) + 1,
					defaultFile = "assets/images/menu/facebook_icon.png", overFile = "assets/images/menu/facebook_icon_over.png",
					width = buttonSize.width, height = buttonSize.height, onRelease = onImageRelease
				}))
				
			end	
		end
		
		
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