-- continuum-mechanics implementation for PrincipalStress
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Eigenvalues(stress)
    assert(#stress==3 and #stress[1]==3,"3x3 stress tensor required")
    local values,vectors=LA.SymmetricEigen(stress,200,1e-12)
    table.sort(values,function(a,b) return a>b end)
    return values,vectors
end

return Module
