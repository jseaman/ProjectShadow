-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

function M:initialize()
	if not self.isInitialized then
		particle_candy.CreateParticleType("HintsMist", {
			imagePath         = { "assets/images/particle/smoke3.png", "assets/images/particle/smoke4.png"},
			imageWidth        = 256,
			imageHeight       = 256,
			velocityStart     = 5,
			velocityVariation = 5,
			alphaStart        = 0,
			--alphaVariation    = 0.15,
			fadeInSpeed       = .055,
			fadeOutSpeed      = -.09,
			fadeOutDelay      = 4500,
			scaleStart        = .5,
			scaleVariation    = .25,
			scaleInSpeed      = .25,
			rotationVariation = 360,
			rotationChange    = 10,
			emissionShape     = 3,
			emissionRadius    = 290,
			killOutsideScreen = false,
			lifeTime          = 7000,
			blendMode         = "screen",
			fxID              = 1,
			colorStart        = {.78,.78,1},
		})

		self.isInitialized = true
	end
end

-----------------------------------------------------------------------------------------

function M:attach(emitterName)
	particle_candy.AttachParticleType(emitterName, "HintsMist", 4, 99999, 0)
end

-----------------------------------------------------------------------------------------

function M:reset()
	self.isInitialized = false
end

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
