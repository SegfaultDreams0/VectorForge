-- continuum-mechanics implementation for DeformationGradient
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.FromDisplacementGradient(gradU)
    local rows,cols=LA.Dimensions(gradU); assert(rows==cols,"displacement gradient must be square")
    return Num.Add(LA.Identity(rows),gradU)
end

return Module
