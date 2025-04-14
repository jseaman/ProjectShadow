-----------------------------------------------------------------------------------------

local ratings = {}

-----------------------------------------------------------------------------------------

ratings.askFrequency = 8
ratings.loaded = false

-----------------------------------------------------------------------------------------

local function loadSettings()
	if not ratings.loaded then
		ratings.settings = io.getFileContentsAsJson("ratings.dat", system.DocumentsDirectory)
		if not ratings.settings then
			ratings.settings = {
				canRate = true,
				hasRated = false,
				currentCheckCount = 0
			}			
		end
		ratings.loaded = true
	end
end

local function saveSettings()
	io.writeFileAsJson(ratings.settings, "ratings.dat", system.DocumentsDirectory)
end

-----------------------------------------------------------------------------------------

local function onFeedbackAlertComplete(event)
	if event.action == "clicked" then		
		local i = event.index
		if i == 1 then
			print("Rating: User does not want to provide feedback.")
			game.analytics.logEvent("ratings.no_feedback")
			ratings.neverRate()
		elseif i == 2 then
			print("Rating: Opening email app for feedback.")
			game.analytics.logEvent("ratings.feedback")
			
			local done = false
			
			if native.canShowPopup("mail") then
				print("Rating: Opening email app seems to be supported. Trying...")
				
				local body = "Target App Store: " .. device.targetAppStore
				body = body .. "\nPlatform: " .. device.platform
				body = body .. "\nPlatform Version: " .. system.getInfo("platformVersion")
				body = body .. "\nApp Version: " .. system.getInfo("appVersionString")
				body = body .. "\n\nUser Comments: "

				done = native.showPopup("mail", {
					to = "contact@squadventure.com",
					subject = "Feedback",
					body = body
				})
			end
			
			if done then
				print("Rating: Opened email app successfully.")
			else
				print("Rating: Opening email app was unsuccessful.")
				native.showAlert(game.info.getGameName(), i18n._"Ratings.Feedback", { i18n._"OK" })
				--system.openURL("mailto:contact@squadventure.com?subject=Feedback" .. "&body=" .. urlencode(body))
			end
			
			ratings.neverRate()
		end
	end
end

local function onRateAlertComplete(event)
	if event.action == "clicked" then
		local i = event.index
		if i == 1 then
			game.analytics.logEvent("ratings.like_no_rate")
		elseif i == 2 then
			ratings.rate()
		end
	end
end

local function onEnjoyAlertComplete(event)
	if event.action == "clicked" then
		local i = event.index
		local game = require("api.game")
		if i == 1 then
			timer.performWithDelay(0, function()
				native.showAlert(game.info.getGameName(), i18n._"Ratings.NotEnjoying", { i18n._"Ratings.NotEnjoying.No", i18n._"Ratings.NotEnjoying.Yes" }, onFeedbackAlertComplete)
			end)
		elseif i == 2 then
			timer.performWithDelay(0, function()
				native.showAlert(game.info.getGameName(), i18n._"Ratings.Enjoying", { i18n._"Ratings.Enjoying.No", i18n._"Ratings.Enjoying.Yes" }, onRateAlertComplete)
			end)
		end
	end
end

-----------------------------------------------------------------------------------------

function ratings.setAskFrequency(value)
	ratings.askFrequency = value or 10
end

-----------------------------------------------------------------------------------------

function ratings.setAlert(value)
	ratings.alert = value
end

-----------------------------------------------------------------------------------------

function ratings.neverRate()
	loadSettings()
	
	ratings.settings.canRate = false
		
	saveSettings()
end

-----------------------------------------------------------------------------------------

function ratings.rate()
	loadSettings()
	
	ratings.settings.hasRated = true
	
	game.analytics.logEvent("ratings.rated")
	
	local game = require("api.game")
	system.openURL(game.info.getGameUrl())
	
	saveSettings()
end

-----------------------------------------------------------------------------------------

function ratings.askRate()
	if ratings.alert then
		--TODO: customize alert
	else
		local game = require("api.game")
		native.showAlert(game.info.getGameName(), i18n._"Ratings.Enjoying?", { i18n._"Ratings.Enjoying?.No", i18n._"Ratings.Enjoying?.Yes" }, onEnjoyAlertComplete)
	end
end

-----------------------------------------------------------------------------------------

function ratings.tryAskRate()
	loadSettings()
	
	if ratings.settings.canRate and not ratings.settings.hasRated then
		ratings.settings.currentCheckCount = ratings.settings.currentCheckCount + 1
		if ratings.settings.currentCheckCount >= ratings.askFrequency then
			ratings.askRate()
			ratings.settings.currentCheckCount = 0
		end
		saveSettings()
	end
end

-----------------------------------------------------------------------------------------

return ratings

-----------------------------------------------------------------------------------------
