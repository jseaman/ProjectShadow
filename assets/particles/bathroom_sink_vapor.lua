-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("BathroomSinkVapor", {
			imagePath         = "assets/images/particle/smoke.png",
			imageWidth         = 128,
			imageHeight        = 128,
			velocityStart     = 25,	
			velocityVariation = 25,
			weight            = -.1,
			alphaStart        = 0,	
			alphaVariation    = 0.0,
			fadeInSpeed       = 0.05,
			fadeOutSpeed      = -0.5,
			fadeOutDelay      = 2000,
			scaleStart        = 1.0,	
			scaleVariation    = 1.5,	
			rotationVariation = 360,	
			rotationChange    = 10,	
			emissionShape     = 1,	
			emissionRadius    = 150,	
			killOutsideScreen = false,
			lifeTime          = 5000,
			blendMode         = "screen",
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "BathroomSinkVapor", 10, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
