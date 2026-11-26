-- quantum-mechanics implementation for WavePacketEvolution
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.FreePhase(psiK,waveNumber,mass,dt)
    assert(#psiK==#waveNumber,"wave number count mismatch"); Num.Positive(mass,"mass"); Num.Nonnegative(dt,"time step")
    local out=table.create(#psiK)
    for i=1,#psiK do
        local phase=-Constants.HBAR*waveNumber[i]^2*dt/(2*mass)
        out[i]=Num.ComplexMul(psiK[i],Num.ComplexExp(phase))
    end
    return out
end

return Module
