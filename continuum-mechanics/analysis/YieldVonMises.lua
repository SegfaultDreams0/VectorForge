-- continuum-mechanics implementation for YieldVonMises
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.EquivalentStress(stress)
    assert(#stress==3 and #stress[1]==3,"3x3 Cauchy stress required")
    local mean=LA.Trace(stress)/3; local deviator=Num.Subtract(stress,Num.Scale(LA.Identity(3),mean))
    return math.sqrt(1.5)*LA.FrobeniusNorm(deviator)
end
function Module.IsYielded(stress,yieldStress)
    Num.Positive(yieldStress,"yield stress"); return Module.EquivalentStress(stress)>=yieldStress
end


-- Tresca comparison stress from principal stresses: max(|s1-s2|,|s2-s3|,|s3-s1|).
function Module.TrescaEquivalent(principalStresses)
    assert(#principalStresses==3,"three principal stresses are required")
    local a,b,c=principalStresses[1],principalStresses[2],principalStresses[3]
    return math.max(math.abs(a-b),math.abs(b-c),math.abs(c-a))
end

-- Return yield margin sigma_y - sigma_vm; negative values indicate yielding.
function Module.YieldMargin(stressTensor,yieldStress)
    Num.Positive(yieldStress,"yield stress")
    return yieldStress-Module.EquivalentStress(stressTensor)
end

return Module
