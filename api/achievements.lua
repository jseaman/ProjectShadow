-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

local list = {
	["torn_letter"] = {id = "CgkIuv30goITEAIQAA", name = "Eye of the Tiger"},
	["hide_from_shade"] = {id = "CgkIuv30goITEAIQAQ", name = "Don't Fear the Reaper"},
	["will_journal"] = {id = "CgkIuv30goITEAIQAg", name = "Stairway to Heaven"},
	["rose"] = {id = "CgkIuv30goITEAIQAw", name = "Every Rose Has Its Thorn"},
	["help_will"] = {id = "CgkIuv30goITEAIQBA", name = "With a Little Help From My Friends"},
	["power_robot"] = {id = "CgkIuv30goITEAIQBQ", name = "Mr. Roboto"},
	["shade_bait"] = {id = "CgkIuv30goITEAIQBg", name = "Hit Me With Your Best Shot"},
	["pick_robot_head"] = {id = "CgkIuv30goITEAIQBw", name = "Don't Lose Your Head"},
	["place_trophy"] = {id = "CgkIuv30goITEAIQCA", name = "We Are the Champions"},
	["check_popenoe_journal"] = {id = "CgkIuv30goITEAIQCQ", name = "Diary of a Madman"},
	["portrait"] = {id = "CgkIuv30goITEAIQCg", name = "Paint It Black"},
	["principal_den_wall"] = {id = "CgkIuv30goITEAIQCw", name = "Another Brick in the Wall"},
	["all_newspaper"] = {id = "CgkIuv30goITEAIQDA", name = "News of the World"},
	["principal_chest"] = {id = "CgkIuv30goITEAIQDQ", name = "I Want it All"},
	["statues"] = {id = "CgkIuv30goITEAIQDg", name = "The Seven Wonders"},
	["teens"] = {id = "CgkIuv30goITEAIQDw", name = "Smells Like Teen Spirit"},
	["open_portal"] = {id = "CgkIuv30goITEAIQEA", name = "Long as I Can See the Light"},
	["ink_bottle"] = {id = "CgkIuv30goITEAIQEQ", name = "Welcome to My Nightmare"},
	["credits"] = {id = "CgkIuv30goITEAIQEg", name = "Show Must Go On"},
	["no_hints"] = {id = "CgkIuv30goITEAIQEw", name = "Don't Stop Believing"},
}

local function achievementExists(name)
	return list[name] ~= nil
end

local function getAchievement(name)
	return list[name]	
end

local function getAchievementId(name)
	local achievement = getAchievement(name)
	if achievement ~= nil then
		return achievement.id
	else
		return nil
	end
end

-----------------------------------------------------------------------------------------

local function _getGameLibrary()
	if device.targetAppStore == "apple" or device.targetAppStore == "google" then
		return require("gameNetwork")
	elseif device.targetAppStore == "amazon" then
		return require("plugin.gamecircle")
	end
end

local function getGameLibrary()
	if not M.gameLibrary then
		M.gameLibrary = _getGameLibrary()
	end
	
	return M.gameLibrary
end

local function onAppleGameCenterInit(event)
	if event.data then
		M.isInitialized = true
		print("Achievements: Apple Game Center connected.")
	else
		print("Achievements: Error while logging into Apple Game Center:", event.errorCode, event.errorMessage)
	end
end

local function onGooglePlayLogin(event)
	if not event.isError then
		M.isInitialized = true
		print("Achievements: Google Play Game Services connected.")
	else
		print("Achievements: Error while logging into Google Play Game Services")
	end
end

local function onGooglePlayInit(event)
	if not event.isError then
		print("Achievements: Google Play Game Services initialized, trying to log in...")
		
		getGameLibrary().request("login",
		{
			listener = onGooglePlayLogin,
			userInitiated = true
		})
	else
		print("Achievements: Error initializing Google Play Game Services")
	end
end

-----------------------------------------------------------------------------------------

function M.initialize()
	if M.isSupported() and not M.isInitialized then
		if device.targetAppStore == "apple" then
			getGameLibrary().init("gamecenter", onAppleGameCenterInit)
		elseif device.targetAppStore == "google" then
			getGameLibrary().init("google", onGooglePlayInit)
		elseif device.targetAppStore == "amazon" then
			getGameLibrary().Init(true, false, false)
		end
	end
end

-----------------------------------------------------------------------------------------

function M.isSupported()
	return device.targetAppStore == "apple" or device.targetAppStore == "google" or device.targetAppStore == "amazon"
end

function M.isConnected()
	if device.targetAppStore == "apple" or device.targetAppStore == "google" then
		return M.isInitialized
	elseif device.targetAppStore == "amazon" then
		return getGameLibrary().IsReady() and getGameLibrary().IsPlayerSignedIn()
	elseif device.isSimulator then
		return true
	else
		return false
	end
end

local function showAchievementWindow(achievement)
	local function onTwitterButtonRelease()
		local url = string.gsub("http://twitter.com/share?text=I just unlocked " .. achievement.name .. " in The Forgotten Pupil&url=http://squadventure.com&hashtags=squadventure,TheForgottenPupil", " ", "%%20")
		system.openURL(url)
		return true
	end
	
	local function onFacebookButtonRelease()
		local url = string.gsub("https://www.facebook.com/sharer/sharer.php?t=I just unlocked " .. achievement.name .. " in The Forgotten Pupil&u=http://squadventure.com", " ", "%%20")
		system.openURL(url)
		return true
	end	
	
	local achievementDisplay = game.ui.newGroup()
	achievementDisplay.alpha = 0
	
	game.ui.insertChild(achievementDisplay, game.ui.newTouchFullScreen(function(event)
		if event.phase == "ended" and achievementDisplay then
			print("Closing Achievement Window")
			achievementDisplay = game.ui.removeSelf(achievementDisplay)
		end
		return true
	end))
	
	local container = game.ui.insertChild(achievementDisplay, game.ui.newRect(
	display.contentWidth/2,  display.contentHeight/2 ,  200, 250,  {0.3, 0.3, 0.3, 0.8}, function()
		return true
	end))
	container.anchorX, container.anchorY = 0.5, 0.5
	
	local relativePos =  {
		sX = container.x - container.contentWidth/2, sY = container.y - container.contentHeight/2,
		eX = container.x + container.contentWidth/2, eY = container.y + container.contentHeight/2
	}
	
	game.ui.insertChild(achievementDisplay, game.ui.newTextBox({
		set_name="Standard", text="Achievement unlocked", color={0.7,0.7,0.7},
		x = display.contentWidth/2 - 150/2, y = relativePos.sY + 10 , size = 12, width = 150, height = 80, align = "center"
	}))
	
	game.ui.insertChild(achievementDisplay, game.ui.newTextBox({
		set_name="Standard", text=achievement.name, color={0.8,0.4,0.6},
		x = display.contentWidth/2 - 150/2, y = relativePos.sY + 30, size = 24, width = 150, height = 80, align = "center"
	}))
	
	local icon = game.ui.insertChild(achievementDisplay, game.ui.newImage(
	achievement.img, display.contentWidth/2,  display.contentHeight/2 ,  100, 100
	))
	icon.anchorX, icon.anchorY = 0.5, 0.5
	icon.alpha = 0
	transition.to( icon, { time=500, xScale=0,  yScale=0, alpha = 0 } )
	
	local twitterButton = game.ui.insertChild(achievementDisplay, game.ui.newButton( display.contentWidth/2 + 35 , relativePos.eY , {
		defaultFile = "assets/images/menu/twitter_icon_over.png", overFile = "assets/images/menu/twitter_icon.png",
		width = 35, height = 35, onRelease = onTwitterButtonRelease
	}))
	twitterButton.alpha = 0
	twitterButton.anchorX, twitterButton.anchorY = 0.5, 0.5
	
	local facebookButton = game.ui.insertChild(achievementDisplay, game.ui.newButton( display.contentWidth/2 - 35 , relativePos.eY , {
		defaultFile = "assets/images/menu/facebook_icon_over.png", overFile = "assets/images/menu/facebook_icon.png",
		width = 35, height = 35, onRelease = onFacebookButtonRelease
	}))
	facebookButton.alpha = 0
	facebookButton.anchorX, facebookButton.anchorY = 0.5, 0.5
	
	transition.scaleTo( achievementDisplay, { alpha=1 ,time=500 } )
	transition.to( icon, { time=	500, delay = 500, transition=easing.outElastic, xScale=1,  yScale=1, alpha = 1 } )
	transition.to( twitterButton, { time=	500, delay = 1000, transition=easing.outExpo, y= relativePos.eY - 20, alpha = 1 } )
	transition.to( facebookButton, { time=	500, delay = 1000, transition=easing.outExpo, y= relativePos.eY - 20, alpha = 1 } )
end

function M.unlock(name)
	print("Achievements: Unlocking achievement: " .. name)	
	
	if M.isConnected() then
		if achievementExists(name) then
			local achievement = getAchievement(name)
			local achievementId = getAchievementId(name)
			
			local game = require("api.game")
			game.data.achievements = game.data.achievements or {}
			
			if game.data.achievements[achievementId] then
				print("Achievements: Already unlocked")
			else
				print("Achievements: Unlocking achievement with ID: " .. achievementId)
				
				--showAchievementWindow(achievement)
				
				if device.targetAppStore == "apple" or device.targetAppStore == "google" then
					getGameLibrary().request("unlockAchievement",
					{
						achievement =
						{
							identifier = achievementId,
							percentComplete = 100,
							showsCompletionBanner = true
						},
						listener = function(event)
							if event.data then
								game.data.achievements[achievementId] = true
								game.markAsChanged()
								print("Achievements: Successfully unlocked")
							else
								print("Achievements: No data received from Google Play Game Services")
							end
						end
					})
				elseif device.targetAppStore == "amazon" then
					getGameLibrary().Achievement.UpdateAchievement(achievementId, 100.0)
				end
			end
		else
			print("Achievements: Invalid achievement name")
		end
	else
		print("Achievements: Connection has not been established")
	end
end

-----------------------------------------------------------------------------------------

function M.show()
	if device.targetAppStore == "apple" or device.targetAppStore == "google" then
		getGameLibrary().show("achievements")
	elseif device.targetAppStore == "amazon" then
		if getGameLibrary().IsReady() then
			getGameLibrary().Achievement.OpenOverlay()
		end
	end
	
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
