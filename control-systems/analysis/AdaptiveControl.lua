-- control-systems implementation for AdaptiveControl
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.MITUpdate(theta,gamma,referenceError,regressor,dt)
    Num.Positive(gamma,"adaptation gain"); Num.Positive(dt,"time step"); assert(#theta==#regressor,"parameter/regressor dimension mismatch")
    local nextTheta=table.clone(theta)
    for i=1,#theta do nextTheta[i]-=gamma*referenceError*regressor[i]*dt end
    return nextTheta
end

return Module
