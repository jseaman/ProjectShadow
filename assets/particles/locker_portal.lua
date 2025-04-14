-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("LockerPortalBeams", {
			imagePath          = "assets/images/particle/beam.png",
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
		particle_candy.CreateParticleType("LockerPortalMist", {
			imagePath         = "assets/images/particle/smoke3.png",
			imageWidth        = 256,
			imageHeight       = 256,
			velocityStart     = 5,
			velocityVariation = 5,
			alphaStart        = 0,
			--alphaVariation    = 0.15,
			fadeInSpeed       = .035,
			fadeOutSpeed      = -.09,
			fadeOutDelay      = 3500,
			scaleStart        = .5,
			scaleVariation    = .25,
			scaleInSpeed      = .25,
			rotationVariation = 360,
			rotationChange    = 10,
			emissionShape     = 3,
			emissionRadius    = 290,
			killOutsideScreen = false,
			lifeTime          = 7000,
			blendMode         = "screen",
			fxID              = 1,
			colorStart        = {.78,.78,1},
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "LockerPortalBeams", 5, 99999, 0)
	particle_candy.AttachParticleType(emitterName, "LockerPortalMist", 4, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
