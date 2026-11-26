-- electromagnetics implementation for SkinDepth
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Compute(frequency,permeability,conductivity)
    Num.Positive(frequency,"frequency"); Num.Positive(permeability,"permeability"); Num.Positive(conductivity,"conductivity")
    return math.sqrt(2/(2*math.pi*frequency*permeability*conductivity))
end

return Module
