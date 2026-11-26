-- signal-processing implementation for HilbertTransform
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("SignalProcessing")
local DFT = require(DomainModules:WaitForChild("models"):WaitForChild("DFT"))
local InverseFFT = require(DomainModules:WaitForChild("analysis"):WaitForChild("InverseFFT"))

local Module = {}
function Module.AnalyticSignal(samples)
    local spectrum=DFT.Compute(samples); local n=#spectrum
    for k=1,n do
        local bin=k-1
        if bin==0 or (n%2==0 and bin==n/2) then
        elseif bin<n/2 then spectrum[k]=Num.ComplexScale(spectrum[k],2)
        else spectrum[k]={Re=0,Im=0} end
    end
    return InverseFFT.Direct(spectrum)
end

return Module
