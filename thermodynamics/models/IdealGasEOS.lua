-- thermodynamics implementation for IdealGasEOS
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.Pressure(moles,T,V)
    Num.Nonnegative(moles,"moles"); Num.Positive(T,"temperature"); Num.Positive(V,"volume")
    return moles*Constants.R*T/V
end
function Module.Density(pressure,molarMass,T)
    Num.Nonnegative(pressure,"pressure"); Num.Positive(molarMass,"molar mass"); Num.Positive(T,"temperature")
    return pressure*molarMass/(Constants.R*T)
end

return Module
