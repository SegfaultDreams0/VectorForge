-- optimization-methods implementation for LevenbergMarquardt
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local Optimizer = require(VectorForge:WaitForChild("NumericalOptimization"))

local Module = {}
function Module.Solve(residual,initial,options)
    return Optimizer.LevenbergMarquardt(residual,initial,options)
end

return Module
