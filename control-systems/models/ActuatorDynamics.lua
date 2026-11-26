-- control-systems implementation for ActuatorDynamics
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.FirstOrder(currentCommand,targetCommand,timeConstant,dt)
    Num.Positive(timeConstant,"actuator time constant"); Num.Positive(dt,"time step")
    local decay=math.exp(-dt/timeConstant)
    return targetCommand+(currentCommand-targetCommand)*decay
end
function Module.RateLimited(command,target,rateLimit,dt)
    Num.Nonnegative(rateLimit,"rate limit"); Num.Nonnegative(dt,"time step")
    local delta=math.max(-rateLimit*dt,math.min(rateLimit*dt,target-command))
    return command+delta
end

return Module
