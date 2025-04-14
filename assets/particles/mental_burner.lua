-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("MentalBurner", {
			imagePath          = "assets/images/particle/flame9.png",
			imageWidth         = 16,
			imageHeight        = 82,
			velocityStart      = 50,	
			alphaStart         = 0,	
			fadeInSpeed        = 2.5,	
			fadeOutSpeed       = -3,
			fadeOutDelay       = 500,
			scaleStart         = 0.2,
			scaleVariation     = 0.3,
			scaleInSpeed       = 1.5,
			weight             = 0,	
			emissionShape      = 0,
			emissionRadius     = 140,
			killOutsideScreen  = true,	
			lifeTime           = 6000, 
			blendMode          = "add", 
			colorChange        = {-.19,-.39,-.49},
			yReference         = -64,
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "MentalBurner", 5, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
