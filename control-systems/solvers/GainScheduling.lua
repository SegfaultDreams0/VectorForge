-- control-systems implementation for GainScheduling
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Interpolate(schedule,operatingPoint)
    assert(#schedule>=1,"gain schedule cannot be empty")
    if operatingPoint<=schedule[1].Point then return LA.Copy(schedule[1].Gain) end
    for i=1,#schedule-1 do
        local a,b=schedule[i],schedule[i+1]
        if operatingPoint<=b.Point then
            local t=(operatingPoint-a.Point)/(b.Point-a.Point)
            return Num.Add(Num.Scale(a.Gain,1-t),Num.Scale(b.Gain,t))
        end
    end
    return LA.Copy(schedule[#schedule].Gain)
end

return Module
