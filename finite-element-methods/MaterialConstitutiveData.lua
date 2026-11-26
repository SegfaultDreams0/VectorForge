-- material constitutive data
local M = {}
function M.Isotropic(young, poisson, density)
    assert(young > 0 and poisson > -1 and poisson < 0.5 and density > 0, "invalid isotropic material")
    local shear = young/(2*(1+poisson))
    local bulk = young/(3*(1-2*poisson))
    return {YoungModulus=young,PoissonRatio=poisson,Density=density,ShearModulus=shear,BulkModulus=bulk}
end
return M
