-- electromagnetics implementation for AmpereLaw
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.EnclosedCurrent(magneticFieldIntegral,permeability)
    Num.Positive(permeability,"permeability"); return magneticFieldIntegral/permeability
end

return Module
