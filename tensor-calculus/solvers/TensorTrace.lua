-- tensor-calculus implementation for TensorTrace
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Mixed(tensor)
    assert(#tensor==#tensor[1],"trace requires a square rank-2 tensor")
    return LA.Trace(tensor)
end

return Module
