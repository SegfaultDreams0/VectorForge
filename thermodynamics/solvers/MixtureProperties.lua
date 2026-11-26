-- thermodynamics implementation for MixtureProperties
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).

local Module = {}
function Module.MoleWeighted(moleFractions,properties)
    assert(#moleFractions==#properties,"component count mismatch")
    local total,result=0,0
    for i=1,#moleFractions do assert(moleFractions[i]>=0 and moleFractions[i]<=1,"invalid mole fraction"); total+=moleFractions[i]; result+=moleFractions[i]*properties[i] end
    assert(math.abs(total-1)<1e-8,"mole fractions must sum to one")
    return result
end
function Module.MolecularMass(moleFractions,molecularMasses)
    return Module.MoleWeighted(moleFractions,molecularMasses)
end

return Module
