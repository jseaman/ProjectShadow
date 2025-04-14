-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("MentalBurnerBubbles2", {
			imagePath          = "assets/images/particle/bubble.png",
			imageWidth         = 128,
			imageHeight        = 128,
			velocityStart      = 50,	
			alphaStart         = 0,	
			fadeInSpeed        = 2.5,	
			fadeOutSpeed       = -3,
			fadeOutDelay       = 500,
			scaleStart         = 0.03,
			scaleVariation     = 0.01,
			scaleInSpeed       = 1.5,
			scaleMax					 = 0.1,
			weight             = 0,	
			emissionShape      = 1,
			emissionRadius     = 15,
			killOutsideScreen  = true,	
			lifeTime           = 3000, 
			blendMode          = "screen", 
			colorStart        = {.82,.82,1},
			yReference         = -64,
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "MentalBurnerBubbles2", 5, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
