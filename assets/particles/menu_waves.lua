-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("MenuWaves", {
			--[[imagePath = { "assets/images/particle/sparks1.png", "assets/images/particle/water_bump.png", "assets/images/particle/sparks1.png" },
			imageWidth         = 128,	
			imageHeight        = 128,	
			velocityStart      = 0,		
			velocityVariation  = 25,		
			alphaStart         = 0.0,	
			alphaVariation     = 0.1,	
			fadeInSpeed        = 0.2,	
			fadeOutSpeed       = -0.5,	
			fadeOutDelay       = 1000,	
			rotationVariation  = 360,	
			scaleStart         = 0.6,	
			scaleVariation     = .3,	
			scaleInSpeed       = .3,	
			scaleOutSpeed      = 0,		
			scaleOutDelay      = 600,	
			weight             = 0.0,	
			useEmitterRotation = false,	
			emissionShape      = 3,		
			emissionRadius     = 400,	
			lifeTime           = 4000,  	
			blendMode          = "add", ]]
			imagePath          = "assets/images/particle/water_ring.png",
			imageWidth         = 128,	
			imageHeight        = 128,	
			velocityStart      = 0,		
			alphaStart         = 0.75,	
			fadeInSpeed        = 0.0,	
			fadeOutSpeed       = -0.5,	
			fadeOutDelay       = 0,		
			scaleStart         = 0.1,	
			scaleVariation     = 0.1,	
			scaleInSpeed       = 2.0,	
			weight             = 0.0,	
			useEmitterRotation = false,	
			--emissionShape      = 3,		
			emissionShape      = 0,		
			emissionRadius     = 400,	
			lifeTime           = 4000,  	
			killOutsideScreen  = false,
			blendMode          = "add",
		})
		
		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	--particle_candy.AttachParticleType(emitterName, "MenuWaves", 20, 5000, 0)
	particle_candy.AttachParticleType(emitterName, "MenuWaves", 1, 5000, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
