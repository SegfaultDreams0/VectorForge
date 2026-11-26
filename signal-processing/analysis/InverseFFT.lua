-- signal-processing implementation for InverseFFT
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Direct(spectrum)
    local n=#spectrum; local signal=table.create(n)
    for j=0,n-1 do
        local sum={Re=0,Im=0}
        for k=0,n-1 do sum=Num.ComplexAdd(sum,Num.ComplexMul(spectrum[k+1],Num.ComplexExp(2*math.pi*j*k/n))) end
        signal[j+1]=Num.ComplexScale(sum,1/n)
    end
    return signal
end

return Module
