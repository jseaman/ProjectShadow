-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("MentalDelusion", {
			imagePath         = "assets/images/particle/beam.png",
			imageWidth        = 128,	
			imageHeight       = 32,	
			xReference        = -64,	
			velocityStart     = 0,	
			alphaStart        = 0,	
			fadeInSpeed       = 1.0,	
			fadeOutSpeed      = -1.0,
			fadeOutDelay      = 1000,
			scaleStart        = 2,
			scaleVariation    = 1.5,
			rotationVariation = 360,	
			rotationChange    = 10,	
			weight            = 0,	
			emissionShape     = 0,	
			killOutsideScreen = true,
			blendMode         = "add",
			lifeTime          = 2000,
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "MentalDelusion", 5, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
