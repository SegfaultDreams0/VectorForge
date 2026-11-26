-- fluid-dynamics implementation for CavitationModel
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.RayleighPlessetAcceleration(radius,radialVelocity,pressureInside,pressureOutside,surfaceTension,viscosity,density)
    Num.Positive(radius,"bubble radius"); Num.Positive(density,"liquid density"); Num.Nonnegative(surfaceTension,"surface tension"); Num.Nonnegative(viscosity,"viscosity")
    local pressureTerm=(pressureInside-pressureOutside-2*surfaceTension/radius-4*viscosity*radialVelocity/radius)/density
    return pressureTerm/radius-1.5*radialVelocity^2/radius
end

return Module
