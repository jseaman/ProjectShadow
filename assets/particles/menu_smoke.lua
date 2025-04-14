-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("MenuSmokeParticles", {
			imagePath = "assets/images/particle/smoke_whispery_bright.png",
			imageWidth = 80,
			imageHeight = 80,
			velocityStart = 25,
			velocityChange = -0.5,
			velocityVariation = 20,
			alphaStart = 0,
			alphaVariation = 0.1,
			alphaMax = 0.2,
			fadeInSpeed	= 1.0,
			fadeOutSpeed = -0.5,
			fadeOutDelay = 2000,
			scaleStart = 0.4,
			scaleVariation = 0.75,
			scaleInSpeed = 0.3,
			scaleMax = 0.8,
			scaleOutSpeed = -0.01,
			scaleOutDelay = 3000,
			rotationVariation = 360,
			rotationChange = 20,
			yReference = 10,
			useEmitterRotation = false,
			weight = -0.02,
			emissionShape = 0,
			emissionRadius = 200,
			killOutsideScreen = false,
			lifeTime = 5000 
		})
		
		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "MenuSmokeParticles", 2, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
