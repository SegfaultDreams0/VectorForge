-- astrodynamics constants
local M = {}
M.Sun = 1.32712440018e20
M.Earth = 3.986004418e14
M.Moon = 4.9048695e12
M.Mars = 4.282837e13
function M.MeanMotion(mu,semiMajorAxis)
    assert(mu > 0 and semiMajorAxis > 0, "invalid orbit parameters")
    return math.sqrt(mu/semiMajorAxis^3)
end
return M
