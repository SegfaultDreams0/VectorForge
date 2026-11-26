-- signal-processing implementation for MatchedFilter
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("SignalProcessing")
local Convolution1D = require(DomainModules:WaitForChild("models"):WaitForChild("Convolution1D"))

local Module = {}
function Module.Correlate(signal,template)
    local reversed=table.create(#template); for i=1,#template do reversed[i]=template[#template-i+1] end
    return Convolution1D.Full(signal,reversed)
end

return Module
