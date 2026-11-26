-- thermodynamics implementation for ThermalConduction
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.FourierRate(conductivity,area,hotTemperature,coldTemperature,thickness)
    Num.Positive(conductivity,"conductivity"); Num.Positive(area,"area"); Num.Positive(thickness,"thickness")
    return conductivity*area*(hotTemperature-coldTemperature)/thickness
end
function Module.ThermalResistance(thickness,conductivity,area)
    Num.Positive(thickness,"thickness"); Num.Positive(conductivity,"conductivity"); Num.Positive(area,"area")
    return thickness/(conductivity*area)
end

return Module
