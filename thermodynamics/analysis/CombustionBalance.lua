-- thermodynamics implementation for CombustionBalance
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).

local Module = {}
function Module.Hydrocarbon( carbon, hydrogen, oxygenInFuel, oxygenAvailable)
    assert(carbon>=0 and hydrogen>=0 and oxygenInFuel>=0 and oxygenAvailable>=0,"atom counts must be nonnegative")
    local required=carbon+hydrogen/4-oxygenInFuel/2
    return {O2Required=math.max(required,0),O2Excess=math.max(oxygenAvailable-required,0),CO2=carbon,H2O=hydrogen/2}
end

return Module
