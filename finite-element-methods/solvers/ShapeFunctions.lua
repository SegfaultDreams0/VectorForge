-- finite-element-methods implementation for ShapeFunctions
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.

local Module = {}
function Module.Lagrange1D(nodes,x)
    local N=table.create(#nodes)
    for i=1,#nodes do local value=1; for j=1,#nodes do if i~=j then value*=(x-nodes[j])/(nodes[i]-nodes[j]) end end; N[i]=value end
    return N
end

return Module
