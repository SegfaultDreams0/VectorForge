local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
-- signal-processing implementation for DFT
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Compute(samples)
    local n=#samples; assert(n>0,"DFT input cannot be empty"); local out=table.create(n)
    for k=0,n-1 do
        local re,im=0,0
        for j=0,n-1 do local phase=-2*math.pi*k*j/n; re+=samples[j+1]*math.cos(phase); im+=samples[j+1]*math.sin(phase) end
        out[k+1]={Re=re,Im=im}
    end
    return out
end


-- Frequency bins for sample rate fs: f_k=k*fs/N.
function Module.FrequencyBins(sampleCount,sampleRate)
    Num = Num or require(game:GetService("ReplicatedStorage"):WaitForChild("VectorForgeShared"):WaitForChild("NumericalKernels"))
    assert(sampleCount>=1 and sampleCount%1==0,"sample count must be a positive integer")
    Num.Positive(sampleRate,"sample rate")
    local bins=table.create(sampleCount)
    for k=0,sampleCount-1 do bins[k+1]=k*sampleRate/sampleCount end
    return bins
end

-- Magnitude and phase arrays from the complex DFT result.
function Module.MagnitudePhase(samples)
    local spectrum=Module.Compute(samples)
    local magnitude,phase=table.create(#spectrum),table.create(#spectrum)
    for k=1,#spectrum do
        magnitude[k]=math.sqrt(spectrum[k].Re^2+spectrum[k].Im^2)
        phase[k]=math.atan2(spectrum[k].Im,spectrum[k].Re)
    end
    return magnitude,phase
end

return Module
