-- signal-processing implementation for SpectralDensity
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("SignalProcessing")
local DFT = require(DomainModules:WaitForChild("models"):WaitForChild("DFT"))

local Module = {}
function Module.Periodogram(samples,sampleRate)
    Num.Positive(sampleRate,"sample rate"); local spectrum=DFT.Compute(samples); local n=#samples; local power=table.create(math.floor(n/2)+1)
    for k=0,math.floor(n/2) do power[k+1]=Num.ComplexAbs2(spectrum[k+1])/(sampleRate*n) end
    local frequency=table.create(#power); for k=0,#power-1 do frequency[k+1]=k*sampleRate/n end
    return frequency,power
end

return Module
