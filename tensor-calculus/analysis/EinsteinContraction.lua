-- tensor-calculus implementation for EinsteinContraction
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ContractRank2(A)
    assert(#A==#A[1],"rank-2 contraction requires square matrix")
    return LA.Trace(A)
end
function Module.ContractRank4(T,firstAxis,thirdAxis)
    assert(firstAxis==1 and thirdAxis==3,"this contraction contracts axes 1 and 3")
    local n=#T; local out=LA.Zeros(#T[1][1],#T[1][1][1])
    for a=1,n do for b=1,#out do for d=1,#out[1] do out[b][d]+=T[a][b][a][d] end end end
    return out
end

return Module
