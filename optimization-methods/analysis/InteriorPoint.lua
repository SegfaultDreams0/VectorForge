-- optimization-methods implementation for InteriorPoint
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.LogBarrier(objective,inequalities,point,barrierWeight)
    Num.Positive(barrierWeight,"barrier weight"); local value=objective(point)
    for _,constraint in ipairs(inequalities) do local slack=-constraint(point); Num.Positive(slack,"strict inequality slack"); value-=barrierWeight*math.log(slack) end
    return value
end
function Module.DecreaseBarrier(weight,mu)
    assert(mu>1,"barrier reduction factor must exceed one"); return weight/mu
end

return Module
