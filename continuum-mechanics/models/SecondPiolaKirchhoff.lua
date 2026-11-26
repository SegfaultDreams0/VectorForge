-- continuum-mechanics implementation for SecondPiolaKirchhoff
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.FromFirstPiola(F,P)
    local inverse=LA.Inverse(F); assert(inverse,"deformation gradient singular")
    return LA.Multiply(inverse,P)
end

return Module
