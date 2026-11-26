-- continuum-mechanics implementation for CauchyStress
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.FromFirstPiola(F,P)
    local J=LA.Determinant(F); Num.Positive(J,"deformation Jacobian")
    return Num.Scale(LA.Multiply(P,LA.Transpose(F)),1/J)
end

return Module
