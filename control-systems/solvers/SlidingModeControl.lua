-- control-systems implementation for SlidingModeControl
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Control(slidingSurface, switchingGain, equivalentControl, boundaryLayer)
    Num.Positive(switchingGain,"switching gain"); boundaryLayer=boundaryLayer or 0
    if boundaryLayer>0 then return equivalentControl-switchingGain*math.max(-1,math.min(1,slidingSurface/boundaryLayer)) end
    return equivalentControl-switchingGain*(if slidingSurface>=0 then 1 else -1)
end

return Module
