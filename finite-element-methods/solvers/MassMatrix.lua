-- finite-element-methods implementation for MassMatrix
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ConsistentBar(density,area,length)
    Num.Positive(density,"density"); Num.Positive(area,"area"); Num.Positive(length,"length")
    local m=density*area*length/6; return {{2*m,m},{m,2*m}}
end

return Module
