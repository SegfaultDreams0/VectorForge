-- quantum-mechanics implementation for EigenstateSolver
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.RealSymmetric(H,iterations,tolerance)
    assert(LA.FrobeniusNorm(Num.Subtract(H,LA.Transpose(H)))<1e-9,"Hamiltonian must be symmetric")
    return LA.SymmetricEigen(H,iterations,tolerance)
end

return Module
