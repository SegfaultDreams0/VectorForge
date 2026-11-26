-- finite-element-methods implementation for MaterialConstitutiveData
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Isotropic(E,nu,density)
    Num.Positive(E,"Young modulus"); Num.Positive(density,"density"); assert(nu>-1 and nu<0.5,"Poisson ratio outside stability range")
    return {YoungModulus=E,PoissonRatio=nu,Density=density,ShearModulus=E/(2*(1+nu)),BulkModulus=E/(3*(1-2*nu))}
end

return Module
