-- tensor-calculus implementation for TensorEigen
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Symmetric(A,iterations,tolerance)
    assert(#A==#A[1],"tensor must be square")
    assert(LA.FrobeniusNorm(Num.Subtract(A,LA.Transpose(A)))<1e-9,"eigensolver requires symmetric tensor")
    return LA.SymmetricEigen(A,iterations,tolerance)
end

return Module
