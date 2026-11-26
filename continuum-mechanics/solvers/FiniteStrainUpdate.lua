-- continuum-mechanics implementation for FiniteStrainUpdate
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ComposeIncrement(incrementalF,totalF)
    assert(LA.Determinant(incrementalF)>0 and LA.Determinant(totalF)>0,"deformation gradients must preserve orientation")
    return LA.Multiply(incrementalF,totalF)
end

return Module
