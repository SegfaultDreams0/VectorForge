-- quantum-mechanics implementation for WKBApproximation
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.Transmission(turningRegionIntegral,hbar)
    Num.Nonnegative(turningRegionIntegral,"barrier action"); hbar=hbar or Constants.HBAR; Num.Positive(hbar,"hbar")
    return math.exp(-2*turningRegionIntegral/hbar)
end
function Module.LocalWaveNumber(potential,energy,mass,hbar)
    Num.Positive(mass,"mass"); Num.Positive(hbar,"hbar")
    return math.sqrt(2*mass*math.abs(energy-potential))/hbar
end

return Module
