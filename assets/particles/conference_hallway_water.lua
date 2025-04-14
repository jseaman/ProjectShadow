-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("ConferenceWaterSprinkle", {
			--imagePath					 = { "assets/images/particle/water4.png", "assets/images/particle/water2.png" },
			imagePath					 = { "assets/images/particle/water_spray.png", "assets/images/particle/water_sparkle.png" },
			imageWidth         = 32,
			imageHeight        = 32,
			weight             = 0.4,
			alphaStart         = 0,
			alphaVariation     = .25,
			fadeInSpeed        = 1.85,
			fadeOutSpeed       = -2,
			fadeOutDelay       = 250,
			scaleStart         = 0.01,
			scaleVariation     = 0.15,
			scaleInSpeed       = 3,
			lifeTime           = 8000,
			emissionShape      = 0,
			emissionRadius     = 50,
			emissionStep       = 50,
			--directionVariation = 15,
			autoOrientation    = true,
			blendMode          = "screen",
			yReference         = 0,
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "ConferenceWaterSprinkle", 20, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
