-- fluid-dynamics implementation for CompressibleFlow
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.

local Module = {}
function Module.NormalShockDownstreamMach(M1,gamma)
    assert(M1>1 and gamma>1,"normal shock requires supersonic upstream Mach and gamma>1")
    return math.sqrt((1+(gamma-1)*M1*M1/2)/(gamma*M1*M1-(gamma-1)/2))
end
function Module.TotalPressureRatio(M1,gamma)
    assert(M1>1 and gamma>1,"normal shock requires supersonic upstream Mach")
    local M2=Module.NormalShockDownstreamMach(M1,gamma)
    local p2p1=1+2*gamma/(gamma+1)*(M1*M1-1)
    local ratio=(1+(gamma-1)*M2*M2/2)^(gamma/(gamma-1))/(1+(gamma-1)*M1*M1/2)^(gamma/(gamma-1))*p2p1
    return ratio
end

return Module
