-- control-systems implementation for ModelPredictiveControl
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Optimizer = require(VectorForge:WaitForChild("NumericalOptimization"))

local Module = {}
function Module.ScalarPlan(a,b,x0,reference,horizon,q,r,limit)
    assert(horizon>=1 and horizon%1==0,"horizon must be positive integer"); Num.Positive(r,"control penalty")
    local function objective(controls)
        local x=x0; local cost=0
        for i=1,horizon do x=a*x+b*controls[i]; cost+=q*(x-reference)^2+r*controls[i]^2 end
        return cost
    end
    local initial=table.create(horizon,0)
    local optimal,info=Optimizer.GradientDescent(objective,initial,{MaximumIterations=150,Tolerance=1e-7})
    for i=1,#optimal do optimal[i]=math.max(-limit,math.min(limit,optimal[i])) end
    return optimal[1],optimal,info
end

return Module
