-- fluid-dynamics implementation for MultiphaseFlow
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.

local Module = {}
function Module.ShanChenForce(density,neighborDensity,links,weights,G)
    assert(#neighborDensity==#links and #links==#weights,"lattice link dimensions mismatch")
    local psi=1-math.exp(-density); local force={0,0}
    for i=1,#links do local psin=1-math.exp(-neighborDensity[i]); force[1]-=G*weights[i]*psi*psin*links[i][1]; force[2]-=G*weights[i]*psi*psin*links[i][2] end
    return force
end

return Module
