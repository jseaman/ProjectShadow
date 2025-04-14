-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("ExpoFire", {
			imagePath          = { "assets/images/particle/flame12.png", "assets/images/particle/flame13.png", "assets/images/particle/flame14.png", 
															"assets/images/particle/flame15.png", "assets/images/particle/flame8.png" },
			imageWidth         = 64,
			imageHeight        = 128,
			velocityStart      = 100,	
			alphaStart         = 0,	
			fadeInSpeed        = 3.5,	
			fadeOutSpeed       = -3,
			fadeOutDelay       = 500,
			scaleStart         = 0.3,
			scaleVariation     = 0.2,
			scaleInSpeed       = 3,
			weight             = -.3,	
			emissionShape      = 0,
			emissionRadius     = 50,
			killOutsideScreen  = false,	
			lifeTime           = 4000, 
			blendMode          = "add", 
			colorChange        = {-.19,-.39,-.5},
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "ExpoFire", 5, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
