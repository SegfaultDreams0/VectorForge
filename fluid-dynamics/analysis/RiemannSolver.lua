-- fluid-dynamics implementation for RiemannSolver
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.

local Module = {}
function Module.HLL(left,right,fluxLeft,fluxRight,speedLeft,speedRight)
    assert(#left==#right and #left==#fluxLeft and #left==#fluxRight,"state and flux dimensions mismatch")
    if speedLeft>=0 then return table.clone(fluxLeft) end
    if speedRight<=0 then return table.clone(fluxRight) end
    assert(speedRight>speedLeft,"wave speed ordering invalid")
    local flux=table.create(#left)
    for i=1,#left do flux[i]=(speedRight*fluxLeft[i]-speedLeft*fluxRight[i]+speedLeft*speedRight*(right[i]-left[i]))/(speedRight-speedLeft) end
    return flux
end

return Module
