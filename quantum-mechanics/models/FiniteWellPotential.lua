-- quantum-mechanics implementation for FiniteWellPotential
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Value(x,width,depth)
    Num.Positive(width,"well width"); Num.Nonnegative(depth,"well depth")
    return math.abs(x)<=width/2 and -depth or 0
end

return Module
