-- signal-processing implementation for ButterworthDesign
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.SecondOrderLowPass(cutoff,sampleRate)
    Num.Positive(cutoff,"cutoff frequency"); Num.Positive(sampleRate,"sample rate"); assert(cutoff<sampleRate/2,"cutoff must be below Nyquist")
    local omega=2*math.pi*cutoff/sampleRate; local cosine=math.cos(omega); local alpha=math.sin(omega)/(2*math.sqrt(2))
    local a0=1+alpha
    return {b0=(1-cosine)/(2*a0),b1=(1-cosine)/a0,b2=(1-cosine)/(2*a0),a1=(-2*cosine)/a0,a2=(1-alpha)/a0}
end

return Module
