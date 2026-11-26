-- fluid material properties
local M = {}
function M.new(density, dynamicViscosity)
    assert(density > 0 and dynamicViscosity >= 0, "invalid fluid properties")
    return {Density=density, DynamicViscosity=dynamicViscosity, KinematicViscosity=dynamicViscosity/density}
end
function M.ReynoldsNumber(density, speed, length, viscosity)
    assert(density > 0 and length > 0 and viscosity > 0, "invalid Reynolds inputs")
    return density*math.abs(speed)*length/viscosity
end
return M
