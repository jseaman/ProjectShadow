-----------------------------------------------------------------------------------------

local particle_candy = require("lib.particle_candy")

-----------------------------------------------------------------------------------------

local particles = {}

-----------------------------------------------------------------------------------------

particles.particles = {}

-----------------------------------------------------------------------------------------

function particles.createEmitter(name, x, y, rotation, visible, loop, autoDestroy)
	assert(name)
	particle_candy.CreateEmitter(name, x, y, rotation, visible, loop, autoDestroy)
end

-----------------------------------------------------------------------------------------

function particles.getEmitter(name)
	return particle_candy.GetEmitter(name)
end

-----------------------------------------------------------------------------------------

function particles.setEmitterScale(name, scale)
	return particle_candy.SetEmitterScale(name, scale)
end

-----------------------------------------------------------------------------------------

function particles.startEmitter(name, oneShot)	
	assert(name)
	particle_candy.WakeUp(true)
	if oneShot == nil then
		oneShot = false
	end
	particle_candy.StartEmitter(name, oneShot)
end

-----------------------------------------------------------------------------------------

function particles.startEmitters(names)
	for i,n in ipairs(names) do
		particles.startEmitter(n)
	end
end

-----------------------------------------------------------------------------------------

function particles.stopEmitter(name)
	assert(name)
	particle_candy.StopEmitter(name)
end

-----------------------------------------------------------------------------------------

function particles.deleteEmitter(name)
	assert(name)
	particle_candy.DeleteEmitter(name)
end

-----------------------------------------------------------------------------------------

function particles.start()
	particle_candy.WakeUp(true)
	particle_candy.StartAutoUpdate()
end

-----------------------------------------------------------------------------------------

function particles.stop()
	particle_candy.StopAutoUpdate()
end

-----------------------------------------------------------------------------------------

function particles.update()
	particle_candy.Update()
end

-----------------------------------------------------------------------------------------

function particles.cleanUp()
	particle_candy.CleanUp()
	
	for p in list_iter(particles.particles) do
		p:reset()
	end
	particles.particles = {}
end

-----------------------------------------------------------------------------------------

local function trackParticle(particle)
	for p in list_iter(particles.particles) do
		if p == particle then
			return p
		end
	end
	table.insert(particles.particles, particle)
	return particle
end

-----------------------------------------------------------------------------------------

function particles.createParticle(particleName, emitterName, x, y)
	assert(emitterName)
	
	local particle = trackParticle(require("assets.particles." .. particleName))
	particle:initialize()
	
	particles.createEmitter(emitterName, x, y, 0, false, true)
	
	particle:attach(emitterName)
	
	return particles.getEmitter(emitterName)
end

-----------------------------------------------------------------------------------------

function particles.createStartedParticle(particleName, emitterName, x, y)
	local particle = particles.createParticle(particleName, emitterName, x, y)
	if particle then
		particles.startEmitter(emitterName)
	end
	return particle
end

-----------------------------------------------------------------------------------------

function particles.changeParticleProperty(particleTypeName, propertyName, value)
	particle_candy.SetParticleProperty(particleTypeName, propertyName, value)
end
 
-----------------------------------------------------------------------------------------

return particles