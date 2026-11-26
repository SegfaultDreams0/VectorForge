-- quantum-mechanics implementation for ExpectationValues
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.RealOperator(operator,psi)
    local applied=LA.MatrixVector(operator,psi)
    local probability=LA.Dot(psi,psi); Num.Positive(probability,"state norm")
    return LA.Dot(psi,applied)/probability
end

return Module
