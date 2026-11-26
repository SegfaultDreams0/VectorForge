-- quantum-mechanics implementation for QuantumUnits
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.EnergyFromFrequency(frequency)
    Num.Nonnegative(frequency,"frequency"); return Constants.H*frequency
end
function Module.ElectronVoltToJoule(value)
    Num.Nonnegative(value,"electronvolts"); return value*Constants.E_CHARGE
end

return Module
