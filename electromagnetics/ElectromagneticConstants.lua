-- electromagnetics implementation for ElectromagneticConstants
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.WaveImpedance(epsilon,mu)
    Num.Positive(epsilon,"permittivity"); Num.Positive(mu,"permeability"); return math.sqrt(mu/epsilon)
end
function Module.Wavelength(frequency)
    Num.Positive(frequency,"frequency"); return Constants.C/frequency
end

return Module
