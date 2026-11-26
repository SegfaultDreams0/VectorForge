-- thermodynamics implementation for EnthalpyModel
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Sensible(mass,specificHeat,T1,T2)
    Num.Nonnegative(mass,"mass"); Num.Positive(specificHeat,"specific heat")
    return mass*specificHeat*(T2-T1)
end
function Module.WithLatent(mass,cp,T1,Tm,T2,latentHeat)
    assert(T1<=Tm and T2>=Tm,"temperatures must cross melting point")
    return mass*(cp*(Tm-T1)+latentHeat+cp*(T2-Tm))
end

return Module
