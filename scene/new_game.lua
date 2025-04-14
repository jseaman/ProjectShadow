-----------------------------------------------------------------------------------------

local widget = require("widget")
local native = require("native")
local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onYesButtonRelease()
  scene:hideOverlay()
	game.startNewAndGo()
	return true
end

local function onNoButtonRelease()
  scene:hideOverlay()
	return true
end

local function onBackgroundTouch(event)
	return true
end

local function onOverlayTouch(event)
  if event.phase == "ended" then
    scene:hideOverlay()
  end
	return true
end

-----------------------------------------------------------------------------------------

function scene:hideOverlay()
  game.stage.playBackSound()
  game.scenes.hideOverlay("fade", 400)
end

-----------------------------------------------------------------------------------------

function scene:shouldRemoveHidden()
  return false
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	local group = self.view
	
	local overlay = game.ui.newRect(0, 0, display.contentWidth, display.contentHeight, {0,0,0, 0.5})
	overlay:addEventListener("touch", onOverlayTouch)
	group:insert(overlay)
	
	--local background = display.newImageRect("assets/images/menu/new_game/background.png", 272, 168)
  local background = game.ui.newRect(device.x(158), device.y(105), 250, 168, {0,0,0, 0.95})
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = device.x(158), device.y(105)
	background.strokeWidth = 2
	background:setStrokeColor(0.9)
	background:addEventListener("touch", onBackgroundTouch)
  background:addEventListener("tap", onBackgroundTouch)
	group:insert(background)
	
	local textBox = game.ui.insertChild(group, game.ui.newTextBox({
		set_name="Standard", text="This will erase your current progress.</n></n>Continue?", color={1,1,1}, 
		x=device.x(185), y = device.y(120), size = 16, width = 232, height = 200, align = "left"
	}))
	
	local yesButton = widget.newButton{
		label="Yes",
    font = fonts.getFontBySetName("Standard"),
    fontSize = 30,
		textOnly = true,
    labelColor = { default={ 1, 1, 1 }, over={ 0, 1, 0, 1 } },
		--defaultFile="assets/images/menu/new_game/yes.png",
		--overFile="assets/images/menu/button_over.png",    
		height = 23, width = 70,
		onRelease=onYesButtonRelease
	}
	yesButton.anchorX, yesButton.anchorY = 0, 0
	yesButton.x, yesButton.y = device.x(315), device.y(224)
	group:insert(yesButton)
	
	local noButton = widget.newButton{
		label="No",
    font = fonts.getFontBySetName("Standard"),
    fontSize = 30,
		textOnly = true,
    labelColor = { default={0.54,0.79,0.62}, over={ 0, 1, 0, 1 } },
		--defaultFile="assets/images/menu/new_game/no.png",
		--overFile="assets/images/menu/button_over.png",
		height = 23, width = 51,
		onRelease=onNoButtonRelease
	}
	noButton.anchorX, noButton.anchorY = 0, 0
	noButton.x, noButton.y = device.x(211), device.y(224)
	group:insert(noButton)
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
	elseif event.phase == "did" then
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		print("hiding")
	elseif event.phase == "did" then
    print("hidden")
	end
end

-----------------------------------------------------------------------------------------

return scene

-----------------------------------------------------------------------------------------