-- quantum-mechanics implementation for VariationalEigenSolver
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.RayleighQuotient(H,trial)
    local hpsi=LA.MatrixVector(H,trial); local denominator=LA.Dot(trial,trial)
    Num.Positive(denominator,"trial vector norm")
    return LA.Dot(trial,hpsi)/denominator
end
function Module.Normalize(trial)
    local magnitude=LA.Norm(trial); Num.Positive(magnitude,"trial vector norm"); return Num.Scale(trial,1/magnitude)
end

return Module
