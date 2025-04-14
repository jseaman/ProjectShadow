-----------------------------------------------------------------------------------------

local info = {}

-----------------------------------------------------------------------------------------

function info.getGameName()
	return "The Mystery of Shadow Hill"
end

-----------------------------------------------------------------------------------------

function info.getGameUrl(name)
	if name == "tlc" then
		if device.targetAppStore == "apple" then
			return "https://itunes.apple.com/us/app/the-lost-chapter/id920173569"
		elseif device.targetAppStore == "google" or device.targetAppStore == "none" then
			return "https://play.google.com/store/apps/details?id=com.squadventure.LostChapter"
		elseif device.targetAppStore == "amazon" then
			return "http://www.amazon.com/gp/mas/dl/android?p=com.squadventure.LostChapter"
		elseif device.targetAppStore == "nook" then
			return "http://www.barnesandnoble.com/w/the-lost-chapter-squadventure/1120871764?ean=2940147240045"
		end
		return nil
	else
		if device.targetAppStore == "apple" then
			return "https://itunes.apple.com/us/app/mystery-of-shadow-hill/id1092973710?ls=1&mt=8"
		elseif device.targetAppStore == "google" or device.targetAppStore == "none" then
			return "https://play.google.com/store/apps/details?id=com.squadventure.ShadowHill"
		elseif device.targetAppStore == "amazon" then
			return "http://www.amazon.com/gp/mas/dl/android?p=com.squadventure.ShadowHill"
		end
	end
end

-----------------------------------------------------------------------------------------

return info

-----------------------------------------------------------------------------------------
