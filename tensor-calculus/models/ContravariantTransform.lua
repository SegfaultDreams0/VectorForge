-- tensor-calculus implementation for ContravariantTransform
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Rank2(T,J)
    assert(#T==#T[1] and #J==#T,"tensor and Jacobian dimensions mismatch")
    return LA.Multiply(LA.Multiply(J,T),LA.Transpose(J))
end

return Module
