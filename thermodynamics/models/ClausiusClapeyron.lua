-- thermodynamics implementation for ClausiusClapeyron
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.PressureAtTemperature(P1,T1,T2,latentHeat)
    Num.Positive(P1,"reference pressure"); Num.Positive(T1,"reference temperature"); Num.Positive(T2,"target temperature"); Num.Positive(latentHeat,"latent heat")
    return P1*math.exp(-latentHeat/Constants.R*(1/T2-1/T1))
end
function Module.Slope(latentHeat,T,deltaV)
    Num.Positive(T,"temperature"); assert(deltaV~=0,"volume change cannot be zero")
    return latentHeat/(T*deltaV)
end

return Module
