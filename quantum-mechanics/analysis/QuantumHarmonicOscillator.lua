-- quantum-mechanics implementation for QuantumHarmonicOscillator
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.EnergyLevel(level,angularFrequency)
    assert(level>=0 and level%1==0,"quantum number must be a nonnegative integer"); Num.Positive(angularFrequency,"angular frequency")
    return Constants.HBAR*angularFrequency*(level+0.5)
end
function Module.WavefunctionScale(mass,omega)
    Num.Positive(mass,"mass"); Num.Positive(omega,"angular frequency")
    return math.sqrt(Constants.HBAR/(mass*omega))
end

return Module
