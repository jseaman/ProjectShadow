device = {
	model = system.getInfo("model"),
	environment = system.getInfo("environment"),
	platform = system.getInfo("platformName"),
	targetAppStore = system.getInfo("targetAppStore"),
	fullWidth = 360,
	fullHeight = 570
}

device.isApple = false
device.isAndroid = false
device.isGoogle = false
device.isKindleFire = false
device.isNook = false
device.is_iPad = false
device.isOuya = false
device.isWinPhone = false
device.isSimulator = false

if (device.environment == "simulator") then
	device.isSimulator = true
end

local model = device.model

if (string.sub(model, 1, 2) == "iP") then
	device.isApple = true
	
	if (string.sub(model, 1, 4) == "iPad") then
		device.is_iPad = true
	end
else
	device.isAndroid = true
	device.isGoogle = true
	
	-- All of the Kindles start with "K", although Corona builds before #976 returned
	-- "WFJWI" instead of "KFJWI" (this is now fixed, and our clause handles it regardless)
	if (model == "Kindle Fire" or model == "WFJWI" or string.sub(model, 1, 2) == "KF") then
		device.isKindleFire = true
		device.isGoogle = false
	end
	
	if (string.sub(model, 1 ,4) == "Nook" or string.sub(model, 1, 4) == "BNRV") then
		device.isNook = true
		device.isGoogle = false
	end
end

if device.targetAppStore == "ouya" then
	device.isOuya = true
end

if device.platform == "WinPhone" then
	device.isWinPhone = true
end

--[[if device.is_iPad then
	device.width = 360
	device.height = 480
elseif device.isApple and display.pixelHeight > 960 then
	device.width = 320
	device.height = 568
elseif device.isApple then
	device.width = 320
	device.height = 480
elseif (display.pixelHeight / display.pixelWidth) > 1.72 then
	device.width = 320
	device.height = 570
else
	device.width = 320
	device.height = 512
end]]

local aspectRatio = display.pixelHeight / display.pixelWidth
device.width = aspectRatio > 1.5 and 320 or math.ceil(480 / aspectRatio)
device.height = aspectRatio < 1.5 and 480 or math.ceil(320 * aspectRatio)

--device.width = 320
--device.height = 480

--device.width = 320
--device.height = 570

application =
{
	content =
	{
		width = device.width,
		height = device.height,
		scale = "letterBox",
		xAlign = "center",
		yAlign = "center",
		antialias = false,
		fps = 30,
		imageSuffix =
		{
			["@2x"] = 1.5,
			["@4x"] = 3.0,
		},
	},
	license =
	{
		google =
		{
			--Production key
			key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiu6FiRDcFaIAl2K+MZK10nTvCKsSsrdQQAdfJJILbInlbnaa7U6yx3Hp/uzY7vuUxFnZod1g8OqBhKzOU1ZCDsMl014m9Nr8fbW9GSBYv5YwIivvL32YhaT03TtUfqKhvx29F4/+7+4N3gxxSO9I8fgp14tjvE2Zn5BUagwsTUS6MoXU0yCpbXV/oEffyFrQw57UnyBhAbmw6Y+I0oOLxxt1iMoreb6JMWtdTZ9IOW8KGBTHeAeX4c3Oa4gyTukSEAj171BnKEufx43gO3HroJGZxtbeQGM3WtqTxBKzzS67jF3CjW0mCGtWau9Zgc6ASTrA6m7uGkdiccADl/X55wIDAQAB"
			--Lite key
			--key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjjqVBg/bnYgB+3Z+5EZ42IIUKLD/amjoXumg/IpD4AhUlOEXWDY/lBFBPgEBHYEc3QCWX0N6Ff1HdAU8ZJKKxe3iA9/g2IRJx7bY3IVu0XITd8fBKdXLR+U67Q5BVi/RgwRNUC6Ry3pkuh7rlKoADKsLFydkXshISbr3QxpxNQP4ScEpD/riGeVwfWQgfS+FFK+Wdte/nKUZrdMpyGLyspNhm7noLLOe+l2O/fjTy53Tk0olQUr+NtgOgICd/J5fLhXS52lgb1z/uGzRL2BxnJaUk/Iv7GPUtLwGQ0ULiyoSurOAnerpZNUkxy/SwUKiQ4HeZCJH0K9ZMvjHq+1l+QIDAQAB"
			--Alpha/beta key
			--key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyD/m1SZvNPXUg/EXViQflJHg1RZFPDSjGTrI+jxXyXvixpYUKK5wNYRM8mZnmMKyYmAujvLLmlQNs5KCTXu2YDIILAe8huCCBr3DL3G6Drk7T51MLJLSqWK+VnMHBgZOCO5T66uA7mR9GiVrHkE1VYaGebiaecaOQHPtqZ2/Ej0AF9uyMS2aD2GLQScoZOCec32A/9urHG6HUbnOPbE5P1jd+igKQY0SwnjjBSNbLfeSKuMW4W9jUDG1mEZGzA+XPt8XBqKxmquNyAUXOxqYe2qDG0KJRtjpHca3MwBh/i0RZL7rTJ+ICXm1c+Conj+qEmqW266ox8xSwlKBV74uCwIDAQAB"
		},
	},
}

device.innerWidth = 480
device.innerHeight = 320
device.contentWidth = device.fullHeight
device.contentHeight = device.fullWidth
device.originY = (device.width - device.fullWidth) / 2
device.originX = (device.height - device.fullHeight) / 2
device.contentCenterX = device.originX + (device.contentWidth / 2)
device.contentCenterY = device.originY + (device.contentHeight / 2)

function device.x(x)
	return device.originX + x
end

function device.y(y)
	return device.originY + y
end

function device.screenX(x)
  return x * display.contentWidth / device.contentWidth
end

function device.screenY(y)
  return y * display.contentHeight / device.contentHeight
end

function device.screenW(w)
  return w * display.contentWidth / device.contentWidth
end

function device.screenH(h)
  return h * display.contentHeight / device.contentHeight
end
