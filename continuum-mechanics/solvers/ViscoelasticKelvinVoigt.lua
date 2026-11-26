-- continuum-mechanics implementation for ViscoelasticKelvinVoigt
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Stress(strain,strainRate,youngModulus,viscosity)
    Num.Nonnegative(viscosity,"viscosity"); Num.Positive(youngModulus,"Young modulus")
    return Num.Add(Num.Scale(strain,youngModulus),Num.Scale(strainRate,viscosity))
end

return Module
