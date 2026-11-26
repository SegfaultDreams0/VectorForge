-- fluid-dynamics implementation for TurbulenceClosure
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.KOmegaEddyViscosity(k,omega,density)
    Num.Nonnegative(k,"turbulent kinetic energy"); Num.Positive(omega,"specific dissipation rate"); Num.Positive(density,"density")
    return density*k/omega
end

return Module
