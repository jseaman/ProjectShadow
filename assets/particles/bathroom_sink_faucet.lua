-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("BathroomSinkFaucetWater1", {
			imagePath          = {"assets/images/particle/water1.png", "assets/images/particle/water8.png"},
			imageWidth         = 40,
			imageHeight        = 128,
			velocityStart      = 200,
			velocityVariation  = 25,
			weight             = 0.75,
			alphaStart         = 0,
			alphaVariation     = .25,
			fadeInSpeed        = 2,
			fadeOutSpeed       = -1,
			fadeOutDelay       = 1000,
			scaleStart         = .15,
			scaleVariation     = .1,
			scaleInSpeed       = .25,
			lifeTime           = 1000,
			autoOrientation    = true,
			blendMode          = "screen",
			killOutsideScreen  = false,
			colorStart         = {.92,.92,1},
		})
		particle_candy.CreateParticleType("BathroomSinkFaucetWater2", {
			imagePath          = "assets/images/particle/water1.png",
			imageWidth         = 128,
			imageHeight        = 256,
			velocityStart      = 100,
			velocityVariation  = 25,
			weight             = 0.75,
			alphaStart         = 0,
			alphaVariation     = .25,
			fadeInSpeed        = 3.5,
			fadeOutSpeed       = -1,
			fadeOutDelay       = 1000,
			scaleStart         = .15,
			scaleVariation     = 0.15,
			scaleInSpeed       = .39,
			lifeTime           = 2500,
			autoOrientation    = true,
			blendMode          = "screen",
			killOutsideScreen  = true,
			yReference         = .75,
			colorStart         = {.92,.92,1},
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "BathroomSinkFaucetWater1", 25, 99999, 0)
	--particle_candy.AttachParticleType(emitterName, "BathroomSinkFaucetWater2", 10, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
