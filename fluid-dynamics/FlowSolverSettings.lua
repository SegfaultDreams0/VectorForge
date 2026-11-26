-- flow solver settings
local M = {}
function M.new()
    return {TimeStep=1/240, Density=1, Viscosity=0.01, PressureIterations=80, Tolerance=1e-7, Relaxation=0.8}
end
function M.Validate(c)
    assert(c.TimeStep > 0 and c.Density > 0 and c.Viscosity >= 0, "invalid flow settings")
    assert(c.PressureIterations >= 1 and c.Tolerance > 0, "invalid solver controls")
    return true
end
return M
