-- quantum-mechanics implementation for SpinPrecession
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.BlochDerivative(state,field,gamma)
    assert(#state==3 and #field==3,"Bloch vectors must have three components")
    local cross=Num.Cross3(field,state)
    return Num.Scale(cross,gamma)
end

return Module
