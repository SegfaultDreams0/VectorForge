-- differential-equations implementation for IntegrationTolerance
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ErrorScale(absolute,relative,reference)
    Num.Positive(absolute,"absolute tolerance"); Num.Positive(relative,"relative tolerance")
    return absolute+relative*math.abs(reference)
end
function Module.Accept(error,absolute,relative,reference)
    return math.abs(error)<=Module.ErrorScale(absolute,relative,reference)
end

return Module
