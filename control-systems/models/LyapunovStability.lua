-- control-systems implementation for LyapunovStability
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.DiscreteSolution(A,Q,tolerance,maxIterations)
    local P=LA.Copy(Q); local tol=tolerance or 1e-10
    for iteration=1,(maxIterations or 10000) do
        local nextP=Num.Add(Q,LA.Multiply(LA.Multiply(LA.Transpose(A),P),A))
        local residual=LA.FrobeniusNorm(Num.Subtract(nextP,P)); P=nextP
        if residual<=tol then return P,{Converged=true,Iterations=iteration,Residual=residual} end
        if LA.FrobeniusNorm(P)>1e100 then return nil,{Converged=false,Reason="Divergent Lyapunov series"} end
    end
    return P,{Converged=false,Reason="Iteration limit reached"}
end


-- Discrete Lyapunov residual A^T P A - P + Q for a candidate certificate.
function Module.Residual(A,P,Q)
    assert(#A==#P and #P==#Q,"Lyapunov dimensions mismatch")
    local residual=LA.Subtract(LA.Add(LA.Multiply(LA.Multiply(LA.Transpose(A),P),A),Q),P)
    return residual,LA.FrobeniusNorm(residual)
end

-- A positive-definite P with negative-definite discrete residual certifies stability.
function Module.CertifyDiscrete(A,P,Q,tolerance)
    local residual,residualNorm=Module.Residual(A,P,Q)
    local pFactor=LA.Cholesky(P)
    local qMinusResidual=LA.Scale(residual,-1)
    local decreaseFactor=LA.Cholesky(qMinusResidual)
    return {PositiveP=pFactor~=nil,StrictDecrease=decreaseFactor~=nil,ResidualNorm=residualNorm,Certified=pFactor~=nil and decreaseFactor~=nil and residualNorm>(tolerance or 0)}
end

return Module
