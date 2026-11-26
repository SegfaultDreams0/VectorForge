-- continuum-mechanics implementation for ElasticMaterialLibrary
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.FromYoungPoisson(E,nu,density)
    Num.Positive(E,"Young modulus"); Num.Positive(density,"density"); assert(nu>-1 and nu<0.5,"Poisson ratio outside stable range")
    return {E=E,Nu=nu,Density=density,Lambda=E*nu/((1+nu)*(1-2*nu)),Mu=E/(2*(1+nu)),Bulk=E/(3*(1-2*nu))}
end

return Module
