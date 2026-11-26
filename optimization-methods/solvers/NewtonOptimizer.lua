-- optimization-methods implementation for NewtonOptimizer
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local AD = require(VectorForge:WaitForChild("AutomaticDifferentiation"))

local Module = {}
function Module.Step(objective,point,damping)
    local gradient=AD.Gradient(objective,point); local hessian=AD.Hessian(objective,point)
    if damping and damping>0 then for i=1,#point do hessian[i][i]+=damping end end
    local step,reason=LA.Solve(hessian,Num.Scale(gradient,-1)); assert(step,reason or "Newton Hessian is singular")
    return Num.Add(point,step),step
end

return Module
