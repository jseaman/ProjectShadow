-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("PrincipalDenWallDust", {
			imagePath         = "assets/images/particle/smoke3.png",
			imageWidth        = 256,
			imageHeight       = 256,
			velocityStart     = 50,	
			velocityVariation = 25,
			velocityChange    = -2,
			weight            = -.05,
			alphaStart        = 0,	
			alphaVariation    = 0.0,
			fadeInSpeed       = .5,
			fadeOutSpeed      = -.25,
			fadeOutDelay      = 2000,
			scaleStart        = .5,	
			scaleVariation    = .5,
			scaleInSpeed      = .35,
			rotationVariation = 360,	
			rotationChange    = 20,	
			emissionShape     = 2,	
			emissionRadius    = 80,	
			killOutsideScreen = false,
			lifeTime          = 5000,
			blendMode         = "screen",
			colorStart        = {1,.58,.19},
			emissionShape      = 1,		
			emissionRadius     = 300,
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "PrincipalDenWallDust", 2, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
