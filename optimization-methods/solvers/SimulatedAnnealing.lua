-- optimization-methods implementation for SimulatedAnnealing
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Accept(currentCost,candidateCost,temperature,uniform)
    Num.Positive(temperature,"temperature"); assert(uniform>0 and uniform<1,"uniform variate must be in (0,1)")
    if candidateCost<currentCost then return true end
    return uniform<math.exp(-(candidateCost-currentCost)/temperature)
end
function Module.Cool(temperature,rate)
    Num.Positive(temperature,"temperature"); assert(rate>0 and rate<1,"cooling rate must be in (0,1)"); return temperature*rate
end

return Module
