-- differential-equations implementation for AdamsMoulton
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Corrector(yPredictor,fPredictor,fCurrent,dt)
    Num.Positive(dt,"step size"); return Num.Add(yPredictor,Num.Scale(Num.Subtract(fCurrent,fPredictor),dt/2))
end
function Module.ImplicitTrapezoid(y,fOld,dt,derivative,maxIterations,tolerance)
    local guess=table.clone(y); local tol=tolerance or 1e-10
    for i=1,(maxIterations or 20) do
        local fNew=derivative(guess); local target=Num.Add(y,Num.Scale(Num.Add(fOld,fNew),dt/2)); local error=LA.Norm(Num.Subtract(target,guess)); guess=target
        if error<tol then return guess,{Converged=true,Iterations=i,Residual=error} end
    end
    return guess,{Converged=false,Iterations=maxIterations or 20}
end

return Module
