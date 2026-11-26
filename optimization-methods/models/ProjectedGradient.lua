-- optimization-methods implementation for ProjectedGradient
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.BoxStep(x,gradient,learningRate,bounds)
    assert(#x==#gradient and #x==#bounds,"projection dimension mismatch"); Num.Positive(learningRate,"learning rate")
    local result=table.create(#x)
    for i=1,#x do local trial=x[i]-learningRate*gradient[i]; result[i]=math.max(bounds[i][1],math.min(bounds[i][2],trial)) end
    return result
end

return Module
