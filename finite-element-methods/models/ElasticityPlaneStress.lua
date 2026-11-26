-- finite-element-methods implementation for ElasticityPlaneStress
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Constitutive(E,nu)
    Num.Positive(E,"Young modulus"); assert(nu>-1 and nu<0.5,"Poisson ratio outside isotropic stability range")
    local f=E/(1-nu*nu)
    return {{f,f*nu,0},{f*nu,f,0},{0,0,f*(1-nu)/2}}
end

return Module
