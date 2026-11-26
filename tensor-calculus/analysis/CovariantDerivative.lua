-- tensor-calculus implementation for CovariantDerivative
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ContravariantVector(partialV,christoffel,V)
    local dim=#V; assert(#partialV==dim and #christoffel==dim,"covariant derivative dimensions mismatch")
    local result=LA.Zeros(dim,dim)
    for k=1,dim do
        for i=1,dim do
            result[k][i]=partialV[k][i]
            for j=1,dim do result[k][i]+=christoffel[i][k][j]*V[j] end
        end
    end
    return result
end
function Module.CovariantCovector(partialW,christoffel,W)
    local dim=#W; local result=LA.Zeros(dim,dim)
    for k=1,dim do for i=1,dim do
        result[k][i]=partialW[k][i]
        for j=1,dim do result[k][i]-=christoffel[j][k][i]*W[j] end
    end end
    return result
end

return Module
