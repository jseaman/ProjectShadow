-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("ExpoExplosionFireball1", {
			imagePath          = { "assets/images/particle/fireball3.jpg", "assets/images/particle/fireball4.jpg", "assets/images/particle/fireball5.jpg" },
			imageWidth        = 256,
			imageHeight       = 256,
			yReference        = .5,
			rotationVariation = 360,
			rotationChange    = 15,
			useEmitterRotation= true,
			alphaStart        = 0.0,
			fadeInSpeed       = 2.0,
			fadeOutSpeed      = -0.5,
			fadeOutDelay      = 500,
			scaleStart        = 0.25,
			scaleVariation    = 0.15,
			scaleInSpeed      = .4,
			scaleMax          = 5,
			emissionShape     = 1,
			emissionRadius    = 130,
			weight            = .015,
			killOutsideScreen = false,
			blendMode         = "screen",
			lifeTime          = 4000,
			colorChange       = {0,-.1,-.1},
		})
		
		particle_candy.CreateParticleType("ExpoExplosionFireball2", {
			imagePath          = { "assets/images/particle/fireball3.jpg", "assets/images/particle/fireball4.jpg", "assets/images/particle/fireball5.jpg" },
			imageWidth        = 256,
			imageHeight       = 256,
			yReference        = .5,
			rotationVariation = 360,
			rotationChange    = 15,
			useEmitterRotation= true,
			alphaStart        = 0.0,
			fadeInSpeed       = 2.0,
			fadeOutSpeed      = -0.5,
			fadeOutDelay      = 500,
			scaleStart        = 0.25,
			scaleVariation    = 0.1,
			scaleInSpeed      = .4,
			scaleMax          = 5,
			emissionShape     = 1,
			emissionRadius    = 130,
			weight            = .015,
			killOutsideScreen = false,
			blendMode         = "screen",
			lifeTime          = 4000,
			colorChange       = {0,-.1,-.1},
		})
		
		particle_candy.CreateParticleType("ExpoExplosionFireTrail", {
			imagePath          = { "assets/images/particle/fireball3.jpg", "assets/images/particle/fireball4.jpg", "assets/images/particle/fireball5.jpg" },
			imageWidth        = 256,
			imageHeight       = 256,
			rotationVariation = 360,
			rotationChange    = 15,
			useEmitterRotation= false,
			alphaStart        = 0.0,
			alphaVariation    = .25,
			fadeInSpeed       = 1.3,
			fadeOutSpeed      = -0.15,
			fadeOutDelay      = 1000,
			scaleStart        = 0.2,
			scaleVariation    = 0.1,
			scaleInSpeed      = .03,
			emissionShape     = 2,
			emissionRadius    = 10,
			killOutsideScreen = false,
			blendMode         = "screen",
			lifeTime          = 20000,
		})
		
		particle_candy.CreateParticleType("ExpoExplosionSparks", {
			imagePath         = "assets/images/particle/sparks1.png",
			imageWidth        = 256,
			imageHeight       = 256,
			yReference        = 0,
			velocityVariation = 20,
			velocityChange    = .2,
			rotationStart     = 0,
			rotationVariation = 360,
			useEmitterRotation= false,
			alphaStart        = 0.0,
			alphaVariation    = .1,
			fadeInSpeed       = .25,
			fadeOutSpeed      = -0.1,
			fadeOutDelay      = 3000,
			scaleStart        = .15,
			scaleVariation    = 0.5,
			scaleInSpeed      = .05,
			scaleMax          = 2,
			emissionShape     = 1,
			emissionRadius    = 150,
			weight            = .01,
			killOutsideScreen = false,
			blendMode         = "screen",
			lifeTime          = 10000,
			colorChange       = {-.05,-.1,-.15},
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "ExpoExplosionSmoke", 6, 6000, 250)
	particle_candy.AttachParticleType(emitterName, "ExpoExplosionFireball1", 6, 7000, 0)
	particle_candy.AttachParticleType(emitterName, "ExpoExplosionFireball2", 6, 7000, 0)
	particle_candy.AttachParticleType(emitterName, "ExpoExplosionFireTrail", 4, 5000, 0)
	particle_candy.AttachParticleType(emitterName, "ExpoExplosionSparks", 3, 5000, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
