-- tensor-calculus implementation for TensorDecomposition
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.SVD(A,sweeps,tolerance)
    local U,S,V=LA.SVD(A,sweeps,tolerance)
    return {U=U,S=S,V=V,Rank=LA.Rank(A,tolerance)}
end

return Module
