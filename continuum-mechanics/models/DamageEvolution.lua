-- continuum-mechanics implementation for DamageEvolution
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.EquivalentStrainUpdate(oldDamage,equivalentStrain,threshold,softeningRate)
    assert(oldDamage>=0 and oldDamage<1,"damage must be in [0,1)"); Num.Nonnegative(equivalentStrain,"equivalent strain"); Num.Nonnegative(threshold,"damage threshold"); Num.Nonnegative(softeningRate,"softening rate")
    if equivalentStrain<=threshold then return oldDamage end
    local candidate=1-math.exp(-softeningRate*(equivalentStrain-threshold))
    return math.max(oldDamage,math.min(candidate,1-1e-12))
end

return Module
