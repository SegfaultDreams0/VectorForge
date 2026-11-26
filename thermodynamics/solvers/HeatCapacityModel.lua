-- thermodynamics implementation for HeatCapacityModel
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.FromCalorimetry(heat,mass,deltaTemperature)
    Num.Positive(mass,"mass"); assert(deltaTemperature~=0,"temperature change cannot be zero")
    return heat/(mass*deltaTemperature)
end
function Module.Polynomial(coefficients,T)
    Num.Nonnegative(T,"temperature"); local cp=0
    for power,coefficient in ipairs(coefficients) do cp+=coefficient*T^(power-1) end
    Num.Positive(cp,"calculated heat capacity"); return cp
end

return Module
