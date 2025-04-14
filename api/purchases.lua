-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

local unlockHintsProductId = "unlock_unlimited_hints"

-----------------------------------------------------------------------------------------

local function _getStoreLibrary()
	if device.targetAppStore == "apple" then
		return require("store")
	elseif device.targetAppStore == "google" then
		return require("plugin.google.iap.v3")
	elseif device.targetAppStore == "amazon" then
		return require("plugin.amazon.iap")
	end
end

local function getStoreLibrary()
	if not M.storeLibrary then
		M.storeLibrary = _getStoreLibrary()
	end
	
	return M.storeLibrary
end

local function getUnlockHintsProductId()
	if device.targetAppStore == "apple" then
		return { unlockHintsProductId }
	elseif device.targetAppStore == "google" or device.targetAppStore == "amazon" then
		return unlockHintsProductId
	end
end

local function onTransaction(event)
	local transaction = event.transaction
	
	print("IAP: Got transaction", transaction.productIdentifier, transaction.state)
	
	if transaction.productIdentifier == unlockHintsProductId then
		if transaction.state == "purchased" then
			print("IAP: Transaction purchased")
			game.state.set("hints_unlocked")
		elseif transaction.state == "restored" then
			print("IAP: Transaction restored")
			game.state.set("hints_unlocked")
		elseif transaction.state == "failed" or transaction.state == "cancelled" then
			print("IAP: Transaction " .. transaction.state)
			if M.isHintsUnlocked() then
				game.state.unset("hints_unlocked")
			elseif M.listener then
				M.listener:onStoreCancelled()
			end
		elseif transaction.state == "refunded" then
			print("IAP: Transaction refunded")
			if M.isHintsUnlocked() then
				game.state.unset("hints_unlocked")
			end
			
			if M.listener then
				M.listener:onGameRefunded()
			end
		end
		
		game.markAsChanged()
		game.save()
	end
	
	getStoreLibrary().finishTransaction(transaction)
end

-----------------------------------------------------------------------------------------

function M.initialize()
	if M.isSupported() and not M.isInitialized then
		if device.targetAppStore == "apple" or device.targetAppStore == "google" or device.targetAppStore == "amazon" then
			getStoreLibrary().init(onTransaction)
			M.isInitialized = true
			print("IAP: Initialized")
			
			M.restore()
		end
	end
end

-----------------------------------------------------------------------------------------

function M.isSupported()
	return device.targetAppStore == "apple" or device.targetAppStore == "google" or device.targetAppStore == "amazon"
end

function M.isConnected()
	if device.targetAppStore == "apple" or device.targetAppStore == "google" or device.targetAppStore == "amazon" then
		return getStoreLibrary().isActive
	else
		return false
	end
end

function M.isEnabled()
	if device.targetAppStore == "apple" or device.targetAppStore == "google" or device.targetAppStore == "amazon" then
		return getStoreLibrary().canMakePurchases
	else
		return false
	end
end

-----------------------------------------------------------------------------------------

function M.isGameUnlocked()
	local state = require("game.state")
	return state.isSet("lite.game_unlocked")
end

-----------------------------------------------------------------------------------------

function M.isHintsUnlocked()
	return game.state.isSet("hints_unlocked")
end

-----------------------------------------------------------------------------------------

function M.unlockHints()
	print("IAP: Unlocking hints...")
	
	if M.isConnected() then
		getStoreLibrary().purchase(getUnlockHintsProductId())
	else
		print("IAP: Connection has not been established")
	end	
end

-----------------------------------------------------------------------------------------

function M.restore()
	print("IAP: Restoring purchases...")
	
	if M.isConnected() then
		getStoreLibrary().restore()
	else
		print("IAP: Connection has not been established")
	end
end

-----------------------------------------------------------------------------------------

function M.setListener(listener)
	M.listener = listener
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------


