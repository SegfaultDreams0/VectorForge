-- finite-element-methods implementation for BarElement1D
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Stiffness(youngModulus,area,length)
    Num.Positive(youngModulus,"Young modulus"); Num.Positive(area,"area"); Num.Positive(length,"length")
    local k=youngModulus*area/length; return {{k,-k},{-k,k}}
end
function Module.AxialStress(force,area)
    Num.Positive(area,"area"); return force/area
end


-- Consistent two-node bar mass: rho*A*L/6 * [[2,1],[1,2]].
function Module.ConsistentMass(density, area, length)
    Num.Positive(density,"density"); Num.Positive(area,"cross-sectional area"); Num.Positive(length,"element length")
    local coefficient=density*area*length/6
    return {{2*coefficient,coefficient},{coefficient,2*coefficient}}
end

-- Linear interpolation and constant axial strain for a two-node element.
function Module.Interpolate(node1,node2,xi)
    assert(xi>=-1 and xi<=1,"parent coordinate must lie in [-1,1]")
    local n1,n2=0.5*(1-xi),0.5*(1+xi)
    return n1*node1+n2*node2
end

function Module.StrainDisplacement(length)
    Num.Positive(length,"element length")
    return {-1/length,1/length}
end

return Module
