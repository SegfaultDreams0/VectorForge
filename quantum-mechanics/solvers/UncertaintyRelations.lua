-- quantum-mechanics implementation for UncertaintyRelations
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.HeisenbergLowerBound(deltaX,deltaP,hbar)
    Num.Nonnegative(deltaX,"position uncertainty"); Num.Nonnegative(deltaP,"momentum uncertainty"); hbar=hbar or Constants.HBAR
    return deltaX*deltaP >= hbar/2
end
function Module.MinimumMomentumSpread(deltaX,hbar)
    Num.Positive(deltaX,"position uncertainty"); return hbar/(2*deltaX)
end

return Module
