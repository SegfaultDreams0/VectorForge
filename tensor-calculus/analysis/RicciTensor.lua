-- tensor-calculus implementation for RicciTensor
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ContractRiemann(R)
    local n=#R; local Ricci=LA.Zeros(n,n)
    for b=1,n do for d=1,n do for a=1,n do Ricci[b][d]+=R[a][b][a][d] end end end
    return Ricci
end

return Module
