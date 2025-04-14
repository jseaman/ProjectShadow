-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("BigBloodSplat", {
			imagePath          = "assets/images/particle/splat_blood1.png",
			imageWidth         = 128,
			imageHeight        = 128,
			velocityStart      = 0,	
			alphaStart         = 1,	
			fadeInSpeed        = 0,	
			fadeOutSpeed       = -0.2,
			fadeOutDelay       = 2000,
			scaleStart         = 0.1,
			scaleVariation     = 0,
			scaleInSpeed       = 10,
			scaleMax           = 2.5,
			rotationVariation  = 360, -- 10
			rotationChange     = 0,
			weight             = 0.001,	
			emissionShape      = 0,
			emissionRadius     = 140,
			killOutsideScreen  = false,	
			lifeTime           = 8000, 
			autoOrientation    = false,	
			useEmitterRotation = false,	
			blendMode          = "alpha", 
			colorChange        = {-.11,-.27,-.27},
		})
		
		particle_candy.CreateParticleType("SmallBloodSplat", {
			imagePath          = "assets/images/particle/splat_blood2.png",
			imageWidth         = 128,
			imageHeight        = 128,
			velocityStart      = -300,
			velocityChange     = -7,
			alphaStart         = 1,	
			fadeInSpeed        = 0,	
			fadeOutSpeed       = -0.2,
			fadeOutDelay       = 2000,
			scaleStart         = 0.1,
			scaleVariation     = 2.0,
			scaleInSpeed       = 13,
			scaleMax           = 2.0,
			faceEmitter        = true,
			weight             = 0.01,	
			emissionShape      = 2,
			emissionRadius     = 50,
			killOutsideScreen  = false,	
			lifeTime           = 8000, 
			autoOrientation    = false,	
			useEmitterRotation = true,
			rotationVariation  = 360, -- 10
			directionVariation = 1,
			blendMode          = "alpha", 
			colorChange        = {-30/255,-70/255,-70/255},
		})
		
		particle_candy.CreateParticleType("BloodDrop", {
			imagePath          = { "assets/images/particle/blood_drip1.png", "assets/images/particle/blood_drip2.png", "assets/images/particle/blood_drip3.png" },
			imageWidth         = 16,
			imageHeight        = 159,
			alphaStart         = 0,		
			alphaVariation     = .15,		
			fadeInSpeed        = .5,	
			fadeOutSpeed       = -.5,	
			fadeOutDelay       = 1000,	
			scaleStart         = 0.01,	
			scaleVariation     = 0.5,
			scaleInSpeed       = 0.6,
			scaleMax           = 2,
			killOutsideScreen  = true,	
			lifeTime           = 6000,
			useEmitterRotation = false,
			rotationStart      = 180,
			blendMode          = "alpha",
			yReference         = 90,
			colorStart         = {.78,0,0},
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "BigBloodSplat", 1, 9999, 0)
	particle_candy.AttachParticleType(emitterName, "SmallBloodSplat", 5, 9999, 0)
	particle_candy.AttachParticleType(emitterName, "BloodDrop", 5, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
