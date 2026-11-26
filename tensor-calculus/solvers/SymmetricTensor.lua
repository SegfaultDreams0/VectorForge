-- tensor-calculus implementation for SymmetricTensor
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Project(A)
    return Num.Scale(Num.Add(A,LA.Transpose(A)),0.5)
end
function Module.IsSymmetric(A,tolerance)
    return LA.FrobeniusNorm(Num.Subtract(A,LA.Transpose(A))) <= (tolerance or 1e-10)
end

return Module
