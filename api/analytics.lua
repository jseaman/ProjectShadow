-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

local apiKey = "UA-24166786-9"

-----------------------------------------------------------------------------------------

local function initialize()
	if not M.analytics and M.isSupported() then
		M.analytics = require("plugin.googleAnalytics")
		if M.analytics then
			M.analytics.init("Mystery of Shadow Hill", apiKey)
		end
	end
end

-----------------------------------------------------------------------------------------

function M.logEvent(eventId)
	if M.isSupported() then
		initialize()
		if M.analytics then
			M.analytics.logEvent("userAction", "generic", eventId)
		end
	end
end

-----------------------------------------------------------------------------------------

function M.logScreen(screenName)
	if M.isSupported() then
		initialize()
		if M.analytics then
			M.analytics.logScreenName(screenName)
		end
	end
end

-----------------------------------------------------------------------------------------

function M.isSupported()
	return device.targetAppStore == "google"
	--return device.targetAppStore == "apple" or device.targetAppStore == "google" --or device.targetAppStore == "amazon"
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------


