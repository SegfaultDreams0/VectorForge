-- optimization-methods implementation for LBFGSOptimizer
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.TwoLoop(gradient,sHistory,yHistory,rhoHistory)
    local q=table.clone(gradient); local alpha=table.create(#sHistory)
    for i=#sHistory,1,-1 do alpha[i]=rhoHistory[i]*LA.Dot(sHistory[i],q); q=Num.Subtract(q,Num.Scale(yHistory[i],alpha[i])) end
    local scale=1
    if #sHistory>0 then local s=sHistory[#sHistory]; local y=yHistory[#yHistory]; scale=LA.Dot(s,y)/math.max(LA.Dot(y,y),1e-30) end
    local r=Num.Scale(q,scale)
    for i=1,#sHistory do local beta=rhoHistory[i]*LA.Dot(yHistory[i],r); r=Num.Add(r,Num.Scale(sHistory[i],alpha[i]-beta)) end
    return Num.Scale(r,-1)
end

return Module
