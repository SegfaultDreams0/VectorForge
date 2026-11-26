-- fluid-dynamics implementation for FreeSurfaceTracking
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.VolumeFractionUpdate(alpha,fluxLeft,fluxRight,dt,dx)
    assert(alpha>=0 and alpha<=1,"volume fraction must be in [0,1]"); Num.Positive(dt,"time step"); Num.Positive(dx,"cell width")
    local nextAlpha=alpha-dt/dx*(fluxRight-fluxLeft)
    assert(nextAlpha>=-1e-10 and nextAlpha<=1+1e-10,"VOF update violated boundedness; reduce time step")
    return math.max(0,math.min(1,nextAlpha))
end

return Module
