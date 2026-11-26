-- thermodynamics implementation for ChemicalPotential
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.FromActivity(referencePotential,temperature,activity)
    Num.Positive(temperature,"temperature"); Num.Positive(activity,"activity")
    return referencePotential+Constants.R*temperature*math.log(activity)
end

return Module
