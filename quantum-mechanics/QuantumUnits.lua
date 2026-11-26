-- quantum units
local M = {}
M.Planck = 6.62607015e-34
M.ReducedPlanck = M.Planck/(2*math.pi)
M.ElectronMass = 9.1093837139e-31
M.ElementaryCharge = 1.602176634e-19
function M.EnergyFromFrequency(frequency)
    assert(frequency >= 0, "frequency must be nonnegative")
    return M.Planck*frequency
end
return M
