-- continuum-mechanics implementation for FirstPiolaKirchhoff
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.FromCauchy(F,cauchyStress)
    local J=LA.Determinant(F); Num.Positive(J,"deformation Jacobian")
    local inverse=LA.Inverse(F); assert(inverse,"deformation gradient is singular")
    return Num.Scale(LA.Multiply(cauchyStress,LA.Transpose(inverse)),J)
end

return Module
