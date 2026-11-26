-- thermodynamics implementation for RefrigerationCycle
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.COP(coolingLoad,workInput)
    Num.Nonnegative(coolingLoad,"cooling load"); Num.Positive(workInput,"work input")
    return coolingLoad/workInput
end
function Module.CarnotCOP(coldTemperature,hotTemperature)
    Num.Positive(coldTemperature,"cold temperature"); assert(hotTemperature>coldTemperature,"hot temperature must exceed cold temperature")
    return coldTemperature/(hotTemperature-coldTemperature)
end

return Module
