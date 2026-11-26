-- control-systems implementation for SensorFusion
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local Bayesian = require(VectorForge:WaitForChild("BayesianStateEstimation"))

local Module = {}
function Module.InformationFuse(estimates)
    return Bayesian.FuseEstimates(estimates)
end

return Module
