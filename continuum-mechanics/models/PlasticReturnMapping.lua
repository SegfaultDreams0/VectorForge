-- continuum-mechanics implementation for PlasticReturnMapping
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.J2RadialReturn(trialDeviatoric,bulkModulus,shearModulus,yieldStress,plasticStrain)
    Num.Positive(bulkModulus,"bulk modulus"); Num.Positive(shearModulus,"shear modulus"); Num.Positive(yieldStress,"yield stress"); Num.Nonnegative(plasticStrain,"equivalent plastic strain")
    local q=math.sqrt(1.5)*LA.FrobeniusNorm(trialDeviatoric)
    local yieldFunction=q-yieldStress
    if yieldFunction<=0 then return LA.Copy(trialDeviatoric),plasticStrain,{Plastic=false,EquivalentTrial=q} end
    local deltaGamma=yieldFunction/(3*shearModulus)
    local corrected=Num.Scale(trialDeviatoric,1-3*shearModulus*deltaGamma/q)
    return corrected,plasticStrain+math.sqrt(2/3)*deltaGamma,{Plastic=true,PlasticIncrement=deltaGamma,EquivalentTrial=q}
end

return Module
