-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("ShowerFaucetWater1", {
			imagePath					 = { "assets/images/particle/water_spray.png", "assets/images/particle/water_sparkle.png" },
			imageWidth         = 24,
			imageHeight        = 24,
			weight             = 0.2,
			alphaStart         = 1,
			alphaVariation     = .25,
			fadeInSpeed        = 1.85,
			fadeOutSpeed       = -0.5,
			fadeOutDelay       = 500,
			scaleStart         = 0.01,
			scaleVariation     = 0.10,
			scaleInSpeed       = 1.5,
			lifeTime           = 1600,
			emissionShape      = 0,
			emissionRadius     = 70,
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
	particle_candy.AttachParticleType(emitterName, "ShowerFaucetWater1", 20, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
