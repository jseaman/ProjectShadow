-----------------------------------------------------------------------------------------

local i18n = {}

-----------------------------------------------------------------------------------------

function i18n._(key)
	return i18n.get(key)
end

function i18n.get(key)
	if i18n.data then
		return i18n.data[key] or ""
	else
		return ""
	end
end

-----------------------------------------------------------------------------------------

local function getSystemLanguage()
	if system.getInfo("platformName") == "Android" then
		return system.getPreference("locale", "language"):lower()
	else
		return system.getPreference("ui", "language"):lower()
	end
end

local function getSystemCountry()
	return system.getPreference("locale", "country"):upper()
end

-----------------------------------------------------------------------------------------

local defaultLanguage = "en_US"
local defaultByLanguage = {
	en = "en_US",
	--es = "es_ES"  --TODO: Uncomment when language file is populated
}

local language = getSystemLanguage()
local country = getSystemCountry()

local languageList = {}
table.insert(languageList, language .. "_" .. country)
if defaultByLanguage[language] then
	table.insert(languageList, defaultByLanguage[language])
end
table.insert(languageList, defaultLanguage)

local loaded = false
for lang in list_iter(languageList) do
	local languagePack = "lang." .. lang
	
	print("Trying to load: " .. languagePack)
	
	if isModuleAvailable(languagePack) then
		local data = require(languagePack)
		if data["__enabled"] == true then
			i18n.data = data
			loaded = true
			print("Loaded.")
			break
		end
	end
end

assert(loaded)

-----------------------------------------------------------------------------------------

return i18n

-----------------------------------------------------------------------------------------