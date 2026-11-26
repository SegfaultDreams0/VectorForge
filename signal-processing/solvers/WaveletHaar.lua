-- signal-processing implementation for WaveletHaar
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("SignalProcessing")
local WaveletPacket = require(DomainModules:WaitForChild("analysis"):WaitForChild("WaveletPacket"))

local Module = {}
function Module.Transform(samples)
    assert(#samples>0 and #samples%2==0,"Haar transform requires even-length samples")
    local approximation,detail=WaveletPacket.HaarLevel(samples)
    return {Approximation=approximation,Detail=detail}
end

return Module
