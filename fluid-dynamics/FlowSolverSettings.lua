-- fluid-dynamics implementation for FlowSolverSettings
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Validate(settings)
    Num.Positive(settings.TimeStep,"time step"); Num.Positive(settings.Density,"density"); Num.Nonnegative(settings.Viscosity,"viscosity")
    assert(settings.CourantLimit>0 and settings.CourantLimit<=1,"Courant limit must be in (0,1]")
    return true
end
function Module.StableTimeStep(cfl,dx,maxSpeed)
    assert(cfl>0 and cfl<=1,"CFL must be in (0,1]"); Num.Positive(dx,"grid spacing"); Num.Positive(maxSpeed,"maximum speed")
    return cfl*dx/maxSpeed
end

return Module
