-- control-systems implementation for RobustHInfinity
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.SISOFrequencyPeak(numerator,denominator,frequencies)
    assert(#denominator>=2,"denominator polynomial required"); local peak=0; local peakFrequency=0
    for _,w in ipairs(frequencies) do
        local nr,ni=0,0; local dr,di=0,0
        for i=1,#numerator do local phase=-(i-1)*math.pi/2; nr+=numerator[i]*w^(i-1)*math.cos(phase); ni+=numerator[i]*w^(i-1)*math.sin(phase) end
        for i=1,#denominator do local phase=-(i-1)*math.pi/2; dr+=denominator[i]*w^(i-1)*math.cos(phase); di+=denominator[i]*w^(i-1)*math.sin(phase) end
        local denominatorMagnitude=math.sqrt(dr*dr+di*di); Num.Positive(denominatorMagnitude,"frequency response denominator")
        local magnitude=math.sqrt(nr*nr+ni*ni)/denominatorMagnitude
        if magnitude>peak then peak=magnitude; peakFrequency=w end
    end
    return peak,{Frequency=peakFrequency,Method="sampled frequency grid"}
end

return Module
