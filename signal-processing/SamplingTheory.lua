-- signal-processing implementation for SamplingTheory
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.NyquistFrequency(sampleRate)
    Num.Positive(sampleRate,"sample rate"); return sampleRate/2
end
function Module.IsUnaliased(frequency,sampleRate)
    return math.abs(frequency)<Module.NyquistFrequency(sampleRate)
end

return Module
