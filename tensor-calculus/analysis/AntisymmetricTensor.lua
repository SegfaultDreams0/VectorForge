-- tensor-calculus implementation for AntisymmetricTensor
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Project(A)
    local AT=LA.Transpose(A)
    return Num.Scale(Num.Subtract(A,AT),0.5)
end
function Module.IsAntisymmetric(A,tol)
    local AT=LA.Transpose(A); local residual=Num.Add(A,AT)
    return LA.FrobeniusNorm(residual) <= (tol or 1e-10)
end

return Module
