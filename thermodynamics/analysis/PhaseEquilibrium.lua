-- thermodynamics implementation for PhaseEquilibrium
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.RaoultPressure(moleFractions,saturationPressures)
    assert(#moleFractions==#saturationPressures,"component count mismatch")
    local pressure=0; local total=0
    for i=1,#moleFractions do
        assert(moleFractions[i]>=0 and moleFractions[i]<=1,"mole fraction outside [0,1]")
        Num.Nonnegative(saturationPressures[i],"saturation pressure")
        pressure+=moleFractions[i]*saturationPressures[i]; total+=moleFractions[i]
    end
    assert(math.abs(total-1)<1e-8,"liquid mole fractions must sum to one")
    return pressure
end

return Module
