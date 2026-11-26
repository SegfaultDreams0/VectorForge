-- optimization-methods implementation for GaussNewton
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local AD = require(VectorForge:WaitForChild("AutomaticDifferentiation"))

local Module = {}
function Module.Solve(residual,initial,maxIterations,tolerance)
    local x=table.clone(initial); local tol=tolerance or 1e-8
    for iteration=1,(maxIterations or 100) do
        local r=residual(x); local J=AD.Jacobian(residual,x); local JT=LA.Transpose(J)
        local normal=LA.Multiply(JT,J); local gradient=LA.MatrixVector(JT,r)
        local step,reason=LA.Solve(normal,Num.Scale(gradient,-1)); assert(step,reason or "Gauss-Newton normal equations singular")
        x=Num.Add(x,step); if LA.Norm(step)<=tol*(LA.Norm(x)+tol) then return x,{Converged=true,Iterations=iteration,Residual=LA.Norm(residual(x))} end
    end
    return x,{Converged=false,Iterations=maxIterations or 100,Residual=LA.Norm(residual(x))}
end

return Module
