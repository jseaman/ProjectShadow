-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then		
		particle_candy.CreateParticleType("AtticLights", {
			imagePath          = "assets/images/game/gym/principal_attic/light.png",
			imageWidth        = 546,
			imageHeight       = 360,
			xReference        = 0,	
			velocityStart     = 0,	
			alphaStart        = 0,	
			fadeInSpeed       = 1.0,	
			fadeOutSpeed      = -1.0,
			fadeOutDelay      = 1000,
			scaleStart        = 1,
			scaleVariation    = 0,
			rotationVariation = 0,	
			rotationChange    = 0,	
			weight            = 0,	
			emissionShape     = 2,
			emissionRadius 	  = 5,
			killOutsideScreen = false,
			blendMode         = "screen",
			lifeTime          = 2000,
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "AtticLights", 3, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
