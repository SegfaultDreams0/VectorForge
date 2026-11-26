-- signal-processing implementation for CepstralAnalysis
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("SignalProcessing")
local DFT = require(DomainModules:WaitForChild("models"):WaitForChild("DFT"))
local InverseFFT = require(DomainModules:WaitForChild("analysis"):WaitForChild("InverseFFT"))

local Module = {}
function Module.RealCepstrum(samples)
    local spectrum=DFT.Compute(samples); local logMagnitude=table.create(#spectrum)
    for i=1,#spectrum do logMagnitude[i]={Re=math.log(math.max(math.sqrt(Num.ComplexAbs2(spectrum[i])),1e-14)),Im=0} end
    local cepstrum=InverseFFT.Direct(logMagnitude); local out=table.create(#cepstrum)
    for i=1,#cepstrum do out[i]=cepstrum[i].Re end
    return out
end

return Module
