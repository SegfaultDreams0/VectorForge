-- thermodynamics implementation for GibbsFreeEnergy
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Change(deltaH,deltaS,temperature)
    Num.Positive(temperature,"absolute temperature")
    return deltaH-temperature*deltaS
end
function Module.Spontaneous(deltaG) return deltaG<0 end

return Module
