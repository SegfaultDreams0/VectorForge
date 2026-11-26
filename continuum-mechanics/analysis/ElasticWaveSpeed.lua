-- continuum-mechanics implementation for ElasticWaveSpeed
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Longitudinal(bulkModulus,shearModulus,density)
    Num.Positive(bulkModulus,"bulk modulus"); Num.Positive(shearModulus,"shear modulus"); Num.Positive(density,"density")
    return math.sqrt((bulkModulus+4*shearModulus/3)/density)
end
function Module.Shear(shearModulus,density)
    Num.Positive(shearModulus,"shear modulus"); Num.Positive(density,"density"); return math.sqrt(shearModulus/density)
end

return Module
