-- optimization-methods implementation for AugmentedLagrangian
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Objective(objective,constraints,multipliers,penalty,x)
    Num.Positive(penalty,"penalty parameter"); local value=objective(x)
    for i=1,#constraints do local c=constraints[i](x); value+=multipliers[i]*c+0.5*penalty*c*c end
    return value
end
function Module.UpdateMultipliers(multipliers,constraintValues,penalty)
    local nextValues=table.create(#multipliers); for i=1,#multipliers do nextValues[i]=multipliers[i]+penalty*constraintValues[i] end; return nextValues
end

return Module
