-- fluid-dynamics implementation for IncompressibleFlow
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ContinuityResidual(u,v,dx,dy,i,j)
    Num.Positive(dx,"dx"); Num.Positive(dy,"dy")
    return (u[i][j+1]-u[i][j-1])/(2*dx)+(v[i+1][j]-v[i-1][j])/(2*dy)
end
function Module.CourantNumber(speed,dt,dx)
    Num.Nonnegative(speed,"speed"); Num.Positive(dt,"time step"); Num.Positive(dx,"grid spacing")
    return speed*dt/dx
end

return Module
