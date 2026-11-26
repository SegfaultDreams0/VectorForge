-- control-systems implementation for TrajectoryTracking
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.PD(referencePosition,referenceVelocity,position,velocity,kp,kd)
    assert(#referencePosition==#position and #referenceVelocity==#velocity,"tracking vector dimensions mismatch")
    local positionError=Num.Subtract(referencePosition,position); local velocityError=Num.Subtract(referenceVelocity,velocity)
    return Num.Add(Num.Scale(positionError,kp),Num.Scale(velocityError,kd))
end

return Module
