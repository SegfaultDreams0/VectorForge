-- differential-equations implementation for BDFSolver
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local AD = require(VectorForge:WaitForChild("AutomaticDifferentiation"))

local Module = {}
function Module.ImplicitEulerStep(previous,dt,derivative,maxIterations,tolerance)
    local guess=table.clone(previous); local tol=tolerance or 1e-10
    for iteration=1,(maxIterations or 30) do
        local nextValue=Num.Add(previous,Num.Scale(derivative(guess),dt)); local residual=LA.Norm(Num.Subtract(nextValue,guess)); guess=nextValue
        if residual<=tol then return guess,{Converged=true,Iterations=iteration,Residual=residual} end
    end
    return guess,{Converged=false,Iterations=maxIterations or 30}
end
function Module.BDF2(current,previous,dt,derivative)
    local function residual(nextState)
        return Num.Subtract(Num.Scale(nextState,1.5),Num.Add(Num.Scale(current,2),Num.Add(Num.Scale(previous,-0.5),Num.Scale(derivative(nextState),dt))))
    end
    local guess=table.clone(current)
    for _=1,40 do local r=residual(guess); if LA.Norm(r)<1e-10 then return guess end; local J=AD.Jacobian(residual,guess); local step,reason=LA.Solve(J,Num.Scale(r,-1)); assert(step,reason or "BDF2 Newton solve failed"); guess=Num.Add(guess,step) end
    error("BDF2 nonlinear solve did not converge")
end

return Module
