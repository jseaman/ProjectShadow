-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("BathroomSinkSpirit", {
			imagePath          = "assets/images/particle/smoke5.png",
			imageWidth         = 32,
			imageHeight        = 32,
			velocityStart      = 3,	
			alphaStart         = 0,	
			alphaVariation	   = 0.3,
			fadeInSpeed        = 0.3,	
			fadeOutSpeed       = -1.0,
			fadeOutDelay       = 1400,
			scaleStart         = 0.05,
			scaleVariation     = 0.1,
			scaleInSpeed       = 1.0,
			rotationVariation  = 360,
			rotationChange     = 15,
			weight             = 0,	
			emissionShape      = 0,
			emissionRadius     = 140,
			killOutsideScreen  = false,	
			lifeTime           = 4000, 
			blendMode          = "screen",
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "BathroomSinkSpirit", 2, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
