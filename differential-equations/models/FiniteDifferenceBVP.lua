-- differential-equations implementation for FiniteDifferenceBVP
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.SecondOrder(coefficients,forcing,leftBoundary,rightBoundary,dx)
    local n=#forcing; assert(#coefficients==n,"coefficient grid mismatch"); Num.Positive(dx,"grid spacing")
    local lower,diag,upper,rhs=table.create(n-1),table.create(n),table.create(n-1),table.create(n)
    for i=1,n do
        local a=coefficients[i]; Num.Positive(a,"diffusion coefficient"); diag[i]=2*a/(dx*dx); rhs[i]=forcing[i]
        if i>1 then lower[i-1]=-a/(dx*dx) end
        if i<n then upper[i]=-a/(dx*dx) end
    end
    rhs[1]+=coefficients[1]*leftBoundary/(dx*dx); rhs[n]+=coefficients[n]*rightBoundary/(dx*dx)
    return Num.TridiagonalSolve(lower,diag,upper,rhs)
end

return Module
