-- optimization-methods implementation for MomentumDescent
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step(parameters,gradient,velocity,learningRate,momentum)
    local nextVelocity=Num.Subtract(Num.Scale(velocity,momentum),Num.Scale(gradient,learningRate))
    return Num.Add(parameters,nextVelocity),nextVelocity
end

return Module
