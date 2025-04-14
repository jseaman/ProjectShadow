-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("ExpoClouds", {
			imagePath         = "assets/images/particle/smoke2.png",
			imageWidth         = 128,
			imageHeight        = 128,
			weight            = -0.005,
			alphaStart        = 0.0,
			alphaMax					= 0.06,
			fadeInSpeed       = 0.05,
			fadeOutSpeed      = -0.1,
			fadeOutDelay      = 13000,
			scaleStart        = 1.0,
			scaleVariation    = 1.5,
			rotationVariation = 360,
			rotationChange    = 10,
			emissionShape     = 1,
			emissionRadius    = 250,
			killOutsideScreen = false,
			lifeTime          = 18000,
			blendMode         = "screen",
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "ExpoClouds", 20, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
