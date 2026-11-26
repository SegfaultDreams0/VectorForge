-- signal-processing implementation for FFT
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Radix2(samples)
    assert(#samples>=1,"FFT input cannot be empty")
    local complex=table.create(#samples)
    for i=1,#samples do
        assert(type(samples[i])=="number","Radix2 expects real-valued samples")
        complex[i]={Re=samples[i],Im=0}
    end
    return Num.FFTComplexRadix2(complex)
end


-- Inverse radix-2 transform uses conjugation and 1/N scaling.
function Module.InverseRadix2(samples)
    assert(#samples>=2 and #samples%1==0,"FFT input length must be a power of two")
    local conjugated=table.create(#samples)
    for i=1,#samples do conjugated[i]={Re=samples[i].Re,Im=-samples[i].Im} end
    local transformed=Num.FFTComplexRadix2(conjugated)
    local inverse=table.create(#samples)
    for i=1,#samples do inverse[i]={Re=transformed[i].Re/#samples,Im=-transformed[i].Im/#samples} end
    return inverse
end

-- One-sided amplitude spectrum for real-valued input after an N-point FFT.
function Module.SingleSidedAmplitude(samples)
    local spectrum=Module.Radix2(samples)
    local n=#samples; local amplitude=table.create(math.floor(n/2)+1)
    for k=0,math.floor(n/2) do
        local magnitude=math.sqrt(spectrum[k+1].Re^2+spectrum[k+1].Im^2)/n
        if k~=0 and not (n%2==0 and k==n/2) then magnitude*=2 end
        amplitude[k+1]=magnitude
    end
    return amplitude
end

return Module
