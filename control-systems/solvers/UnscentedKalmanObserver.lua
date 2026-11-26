-- control-systems implementation for UnscentedKalmanObserver
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local Bayesian = require(VectorForge:WaitForChild("BayesianStateEstimation"))

local Module = {}
function Module.Create(configuration)
    local filter=Bayesian.UKF.new(configuration)
    return {Predict=function(self,control,dt) return filter:Predict(control,dt) end,
        Update=function(self,measurement) return filter:Update(measurement) end,
        GetEstimate=function() return filter:GetEstimate() end,
        Reset=function(self,state,covariance) return filter:Reset(state,covariance) end}
end

return Module
