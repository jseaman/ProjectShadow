-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("HintsCharmFairyDust", {
			imagePath          = "assets/images/particle/colored_stars.png",
			imageWidth         = 128,
			imageHeight        = 128,
			velocityStart      = 50,	
			velocityVariation  = 25,
			directionVariation = 45,
			alphaStart         = 0,		
			alphaVariation     = .25,		
			fadeInSpeed        = 3.0,	
			fadeOutSpeed       = -.5,	
			fadeOutDelay       = 500,	
			scaleStart         = 0.01,	
			scaleVariation     = 0.25,
			scaleInSpeed       = .5,
			weight             = -0.1,	
			rotationVariation  = 360,
			rotationChange     = 40,
			killOutsideScreen  = true,	
			lifeTime           = 4000,  
			useEmitterRotation = false,	
			emissionShape      = 2,		
			emissionRadius     = 15,
			blendMode          = "add",
			colorStart         = {1,1,.58},
		})
		particle_candy.CreateParticleType("HintsCharmFlash", {
			imagePath          = "assets/images/particle/flare.png",
			imageWidth         = 128,
			imageHeight        = 128,
			directionVariation = 360,
			rotationVariation  = 360,
			rotationChange     = 30,
			useEmitterRotation = false,
			alphaStart         = 0.0,
			fadeInSpeed        = 4.0,
			fadeOutSpeed       = -2.0,
			fadeOutDelay       = 250,
			scaleStart         = 4.0,
			scaleInSpeed       = 1.5,
			scaleOutSpeed      = -1.0,
			scaleOutDelay      = 0,
			killOutsideScreen  = false,
			emissionShape      = 2,		
			emissionRadius     = 5,
			blendMode          = "add",
			lifeTime           = 3000,
			colorStart        = {.58,1,.58},
		})
		particle_candy.CreateParticleType("HintsCharmFireflies", {
			imagePath          = "assets/images/particle/flare.png",
			imageWidth         = 128,
			imageHeight        = 128,
			velocityStart      = 50,
			velocityVariation  = 50,
			weight             = -.1,
			rotationVariation  = 360,
			rotationChange     = 30,
			useEmitterRotation = true,
			alphaStart         = 0.0,
			fadeInSpeed        = .5,
			fadeOutSpeed       = -.5,
			fadeOutDelay       = 1000,
			scaleStart         = .1,
			scaleVariation     = .3,
			killOutsideScreen  = true,
			emissionShape      = 1,		
			emissionRadius     = 400,
			blendMode          = "add",
			lifeTime           = 5000,
			colorStart         = {.58,1,.58},
		})
		particle_candy.CreateParticleType("HintsCharmSmoke", {
			imagePath         = "assets/images/particle/smoke3.png",
			imageWidth        = 256,
			imageHeight       = 256,
			velocityStart     = 125,	
			velocityVariation = 25,
			velocityChange    = -2,
			weight            = -.1,
			alphaStart        = 0,	
			alphaVariation    = 0.0,
			fadeInSpeed       = 1,
			fadeOutSpeed      = -1,
			fadeOutDelay      = 750,
			scaleStart        = .15,	
			scaleVariation    = .25,
			scaleInSpeed      = .5,
			rotationVariation = 360,	
			rotationChange    = 20,	
			emissionShape     = 2,	
			emissionRadius    = 20,	
			killOutsideScreen = false,
			lifeTime          = 3000,
			blendMode         = "screen",
			colorStart        = {.58,1,.58},
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "HintsCharmSmoke", 5, 99999, 0)
	particle_candy.AttachParticleType(emitterName, "HintsCharmFairyDust", 15, 99999, 0)
	particle_candy.AttachParticleType(emitterName, "HintsCharmFlash", 2, 99999, 0)
	particle_candy.AttachParticleType(emitterName, "HintsCharmFireflies", 15, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
