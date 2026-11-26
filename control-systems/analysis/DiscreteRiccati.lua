-- control-systems implementation for DiscreteRiccati
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Solve(A,B,Q,R,tolerance,maxIterations)
    local P=LA.Copy(Q); local tol=tolerance or 1e-10
    for iteration=1,(maxIterations or 1000) do
        local BtP=LA.Multiply(LA.Transpose(B),P); local S=Num.Add(R,LA.Multiply(BtP,B))
        local Sinv,reason=LA.Inverse(S); assert(Sinv,reason or "Riccati control denominator singular")
        local At=LA.Transpose(A); local AtPA=LA.Multiply(LA.Multiply(At,P),A)
        local correction=LA.Multiply(LA.Multiply(LA.Multiply(LA.Multiply(At,P),B),Sinv),LA.Multiply(BtP,A))
        local nextP=LA.Symmetrize(Num.Add(Num.Subtract(AtPA,correction),Q))
        local change=LA.FrobeniusNorm(Num.Subtract(nextP,P)); P=nextP
        if change<=tol then
            local gain=LA.Multiply(LA.Multiply(Sinv,BtP),A)
            return P,gain,{Converged=true,Iterations=iteration,Residual=change}
        end
    end
    return P,nil,{Converged=false,Iterations=maxIterations or 1000,Residual=math.huge}
end

return Module
