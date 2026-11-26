-- continuum-mechanics implementation for HookeConstitutive
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.IsotropicStress(strain,youngModulus,poissonRatio)
    Num.Positive(youngModulus,"Young modulus"); assert(poissonRatio>-1 and poissonRatio<0.5,"Poisson ratio outside stable range")
    local lambda=youngModulus*poissonRatio/((1+poissonRatio)*(1-2*poissonRatio)); local mu=youngModulus/(2*(1+poissonRatio))
    local trace=LA.Trace(strain); local stress=Num.Scale(strain,2*mu)
    for i=1,#strain do stress[i][i]+=lambda*trace end
    return stress
end

return Module
