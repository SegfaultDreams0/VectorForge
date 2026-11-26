-- differential-equations implementation for SpectralCollocation
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ChebyshevDifferentiation(order)
    local x=Num.ChebyshevGrid(order); local c=table.create(order+1)
    for i=0,order do c[i+1]=(if i==0 or i==order then 2 else 1)*(if i%2==0 then 1 else -1) end
    local D=LA.Zeros(order+1,order+1)
    for i=0,order do for j=0,order do if i~=j then D[i+1][j+1]=c[i+1]/(c[j+1]*(x[i+1]-x[j+1])) end end end
    for i=1,order do local sum=0; for j=1,order+1 do if i~=j then sum+=D[i][j] end end; D[i][i]=-sum end
    return x,D
end

return Module
