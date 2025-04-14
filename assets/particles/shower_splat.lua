-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("ConferenceWaterSplatsSmall", {
			imagePath					 = "assets/images/particle/water_splat1.png",
			imageWidth         = 64,
			imageHeight        = 16,
			alphaStart         = .25,
			alphaVariation     = .25,
			fadeInSpeed        = 1.5,
			fadeOutSpeed       = -2,
			fadeOutDelay       = 250,
			scaleStart         = 0.1,
			scaleVariation     = 0.1,
			scaleInSpeed       = 0.6,
			maxScale           = .2,
			lifeTime           = 1000,
			emissionShape      = 0,
			emissionShape      = 1,
			emissionRadius     = 45,
			blendMode          = "alpha",
			yReference         = 0,
			colorStart         = {1,1,1},
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "ConferenceWaterSplatsSmall", 5, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
