-- continuum-mechanics implementation for GreenLagrangeStrain
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Compute(F)
    local CauchyGreen=LA.Multiply(LA.Transpose(F),F)
    return Num.Scale(Num.Subtract(CauchyGreen,LA.Identity(#F)),0.5)
end

return Module
