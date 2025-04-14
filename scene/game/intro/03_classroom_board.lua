-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:appendQuestions(str)
  scene.questionsText = scene.questionsText or ""
  scene.questionsText = scene.questionsText .. str
  scene.questionsTextBox:changeProperty({ text = scene.questionsText })
end

-----------------------------------------------------------------------------------------

function scene:startWritingLine(lines, index)
  if index > #lines then
		scene.continueText:show()
    game.hud.showMyCaption(i18n._"Intro.AllAboutQuestions!", function()
      game.scenes.gotoGameScene("game.intro.04_hallway", "fade", 2000)
    end)
    return
  end
  local line = lines[index]
  local currentPos = 1
  
  scene.textScrollTimer = scene:newTimer(65, function()
			if scene.textScrollTimer then
        scene:appendQuestions("<span size={" .. math.random(17,19) .. "}>")
        scene:appendQuestions(string.sub(line, currentPos, currentPos))
        scene:appendQuestions("</span>")
				currentPos = currentPos + 1
        
        if currentPos > string.len(line) then    
					scene.textScrollTimer = game.ui.cancelTimer(scene.textScrollTimer)
					scene:appendQuestions("</n></n>")
          --[[for i = 0, math.random(0,2) do
            scene:appendQuestions(" ")
          end]]
          scene:startWritingLine(lines, index + 1)
				end
			end
		end, 0)
end

-----------------------------------------------------------------------------------------

function scene:startWriting()
  self:playSound("chalk")
  local lines = i18n._"Intro.QuestionsList"
  scene:startWritingLine(lines, 1)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self:addToScene(game.ui.newBackground("assets/images/game/intro/chalkboard_zoom.jpg"))
  
  self:addToScene(game.ui.newTextBox({
    text = i18n._"Intro.Questions", set_name = "Chalk", size = 20, align = "left", color = {1,1,1},
    x = device.x(85), y = device.y(70), width = 190, height = 300}))

  self.questionsTextBox = self:addToScene(game.ui.newTextBox({
    text = "", set_name = "Chalk", size = 18, align = "left", color = {1,1,1},
    x = device.x(90), y = device.y(120), width = 390, height = 330}))

  self.questionsText = ""
	
	self.continueText = self:addToHUD(game.ui.newTapToContinueText(true))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("chalk", "assets/sounds/game/intro/chalk_full.mp3")
	elseif event.phase == "did" then
    scene:newTimer(1000, function()
      scene:startWriting()
    end)
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