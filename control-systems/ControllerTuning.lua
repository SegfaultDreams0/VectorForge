-- control-systems implementation for ControllerTuning
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.PID(kp,ki,kd,outputLimit)
    assert(kp>=0 and ki>=0 and kd>=0,"PID gains must be nonnegative"); Num.Positive(outputLimit,"output limit")
    return {Kp=kp,Ki=ki,Kd=kd,OutputLimit=outputLimit}
end

return Module
