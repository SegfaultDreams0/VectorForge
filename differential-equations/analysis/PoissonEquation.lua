-- differential-equations implementation for PoissonEquation
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Solve1D(source,length,leftValue,rightValue)
    local n=#source; assert(n>=1,"source grid cannot be empty"); Num.Positive(length,"domain length")
    local dx=length/(n+1); local lower=table.create(n-1,-1); local diag=table.create(n,2); local upper=table.create(n-1,-1); local rhs=table.create(n)
    for i=1,n do rhs[i]=source[i]*dx*dx end
    rhs[1]+=leftValue; rhs[n]+=rightValue
    return Num.TridiagonalSolve(lower,diag,upper,rhs)
end

return Module
