function EFFECT:Init(data)
	local pemitter = ParticleEmitter(data:GetOrigin())
		for i=0, 48 do
			if !pemitter then return end
			local Pos = (data:GetOrigin() + Vector( math.Rand(-32,32), math.Rand(-32,32), math.Rand(-32,32) ) + Vector(0,0,64))
			local particle = pemitter:Add( "particle/particle_smokegrenade", Pos )
			if (particle) then
				particle:SetVelocity(VectorRand() * math.Rand(1000,4000))
				particle:SetLifeTime(0)
				particle:SetDieTime(15 + math.Rand(-2,2))
				local rand = math.random(200,255)
				particle:SetColor(20,rand,20)
				particle:SetStartAlpha(math.Rand(242,255))
				particle:SetEndAlpha(0)
				local Size = math.Rand(162,200)
				particle:SetStartSize(Size)
				particle:SetEndSize(Size)
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				particle:SetAirResistance(math.Rand(520,620))
				particle:SetGravity( Vector(0, 0, math.Rand(-42, -82)) )
				particle:SetCollide(true)
				particle:SetBounce(0.1)
				particle:SetLighting(1)
			end
		end
	pemitter:Finish()
end
function EFFECT:Think()
return false
end
function EFFECT:Render()
end