-- finite-element-methods implementation for QuadrilateralElement2D
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.

local Module = {}
function Module.BilinearShape(xi,eta)
    return {(1-xi)*(1-eta)/4,(1+xi)*(1-eta)/4,(1+xi)*(1+eta)/4,(1-xi)*(1+eta)/4}
end
function Module.NaturalDerivatives(xi,eta)
    return {{-(1-eta)/4,-(1-xi)/4},{(1-eta)/4,-(1+xi)/4},{(1+eta)/4,(1+xi)/4},{-(1+eta)/4,(1-xi)/4}}
end

return Module
