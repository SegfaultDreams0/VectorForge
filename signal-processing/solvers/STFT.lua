-- signal-processing implementation for STFT
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("SignalProcessing")
local DFT = require(DomainModules:WaitForChild("models"):WaitForChild("DFT"))

local Module = {}
function Module.Analyze(samples,frameSize,hopSize,window)
    assert(frameSize>=2 and hopSize>=1 and frameSize%1==0 and hopSize%1==0,"invalid STFT dimensions")
    local frames={}; local weights=window or table.create(frameSize,1)
    assert(#weights==frameSize,"window length mismatch")
    for start=1,#samples-frameSize+1,hopSize do
        local frame=table.create(frameSize)
        for i=1,frameSize do frame[i]=samples[start+i-1]*weights[i] end
        table.insert(frames,{Start=start,Spectrum=DFT.Compute(frame)})
    end
    return frames
end

return Module
