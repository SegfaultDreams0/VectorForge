-- thermodynamics implementation for CarnotCycle
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Efficiency(coldTemperature,hotTemperature)
    Num.Positive(coldTemperature,"cold temperature"); Num.Positive(hotTemperature,"hot temperature")
    assert(hotTemperature>coldTemperature,"hot reservoir must be hotter")
    return 1-coldTemperature/hotTemperature
end

return Module
