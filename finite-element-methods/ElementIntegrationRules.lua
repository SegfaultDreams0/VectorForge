-- finite-element-methods implementation for ElementIntegrationRules
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.

local Module = {}
function Module.TriangleCentroid()
    return {{Xi=1/3,Eta=1/3,Weight=0.5}}
end
function Module.TetrahedronCentroid()
    return {{Xi=0.25,Eta=0.25,Zeta=0.25,Weight=1/6}}
end

return Module
