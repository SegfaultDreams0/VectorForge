-- continuum-mechanics implementation for ConstitutiveModelSettings
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Validate(settings)
    Num.Positive(settings.Tolerance,"constitutive tolerance"); assert(settings.MaxIterations>=1 and settings.MaxIterations%1==0,"maximum iterations must be positive integer")
    return true
end

return Module
