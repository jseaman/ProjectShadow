-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("ConferenceShock", {
			imagePath          = { "assets/images/particle/electric_arc6.png", "assets/images/particle/electric_arc5.png",
														 "assets/images/particle/electric_arc4.png", "assets/images/particle/electric_arc3.png",
														 "assets/images/particle/electric_arc2.png", "assets/images/particle/electric_arc1.png",
														 "assets/images/particle/electric_arc0.png", "assets/images/particle/electric_arc.png",
													 },
			imageWidth         = 256,
			imageHeight        = 128,
			directionVariation = 45,
			alphaStart         = .5,
			alphaVariation     = .25,
			fadeInSpeed        = 4.0,
			fadeOutSpeed       = -2.0,
			fadeOutDelay       = 0,
			scaleStart         = .1,
			scaleInSpeed       = 0,
			weight             = 0,
			killOutsideScreen  = true,
			lifeTime           = 4000,
			useEmitterRotation = false,
			emissionShape      = 0,
			emissionRadius     = 15,
			blendMode          = "add",
			yReference         = 75,
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "ConferenceShock", 7, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
