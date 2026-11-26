-- optimization-methods implementation for GradientDescent
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local Optimizer = require(VectorForge:WaitForChild("NumericalOptimization"))

local Module = {}
function Module.Minimize(objective,initial,options)
    return Optimizer.GradientDescent(objective,initial,options)
end

return Module
