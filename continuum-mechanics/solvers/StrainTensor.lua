-- continuum-mechanics implementation for StrainTensor
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("ContinuumMechanics")
local GreenLagrangeStrain = require(DomainModules:WaitForChild("analysis"):WaitForChild("GreenLagrangeStrain"))

local Module = {}
function Module.RightCauchyGreen(F)
    return LA.Multiply(LA.Transpose(F),F)
end
function Module.GreenLagrange(F)
    return GreenLagrangeStrain.Compute(F)
end

return Module
