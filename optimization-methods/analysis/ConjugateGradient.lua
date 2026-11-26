-- optimization-methods implementation for ConjugateGradient
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local AD = require(VectorForge:WaitForChild("AutomaticDifferentiation"))

local Module = {}
function Module.PolakRibiere(objective,initial,maxIterations,tolerance)
    local x=table.clone(initial); local g=AD.Gradient(objective,x); local direction=Num.Scale(g,-1); local tol=tolerance or 1e-8
    for iteration=1,(maxIterations or 500) do
        if LA.Norm(g)<=tol then return x,{Converged=true,Iterations=iteration-1,GradientNorm=LA.Norm(g)} end
        local alpha=1
        while alpha>1e-12 and objective(Num.Add(x,Num.Scale(direction,alpha)))>objective(x)+1e-4*alpha*LA.Dot(g,direction) do alpha*=0.5 end
        local nextX=Num.Add(x,Num.Scale(direction,alpha)); local nextG=AD.Gradient(objective,nextX)
        local difference=Num.Subtract(nextG,g); local beta=math.max(0,LA.Dot(nextG,difference)/math.max(LA.Dot(g,g),1e-30))
        direction=Num.Add(Num.Scale(nextG,-1),Num.Scale(direction,beta)); x=nextX; g=nextG
    end
    return x,{Converged=false,Iterations=maxIterations or 500,GradientNorm=LA.Norm(g)}
end

return Module
