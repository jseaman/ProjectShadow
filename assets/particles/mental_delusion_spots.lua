-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("MentalDelusionSpots", {
			imagePath         = "assets/images/particle/light.png",
			imageWidth           = 128,
			imageHeight          = 64,
			velocityStart        = 150,	
			rotationStart        = 0,
			autoOrientation      = false,
			killOutsideScreen    = true,	
			lifeTime             = 4000, 
			alphaStart           = 0,
			scaleStart           = 1.0,
			scaleVariation       = 1.2,
			fadeInSpeed          = 1.5,	
			fadeOutSpeed         = -0.75,
			fadeOutDelay         = 2000,	
			emissionShape        = 2,
			emissionRadius       = 200,
			blendMode            = "add",
			randomMotionMode     = 2,	
			randomMotionInterval = 1000,	
			randomMotionAmount   = 360,	
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "MentalDelusionSpots", 10, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
