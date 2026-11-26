-- finite-element-methods implementation for ThermalElement
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.BarStiffness(conductivity,area,length)
    Num.Positive(conductivity,"conductivity"); Num.Positive(area,"area"); Num.Positive(length,"length")
    local value=conductivity*area/length
    return {{value,-value},{-value,value}}
end
function Module.BarCapacity(density,specificHeat,area,length)
    Num.Positive(density,"density"); Num.Positive(specificHeat,"specific heat"); Num.Positive(area,"area"); Num.Positive(length,"length")
    local value=density*specificHeat*area*length/6
    return {{2*value,value},{value,2*value}}
end

return Module
