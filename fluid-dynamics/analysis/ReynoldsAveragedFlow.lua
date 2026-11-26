-- fluid-dynamics implementation for ReynoldsAveragedFlow
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.EddyViscosity(k,epsilon,Cmu)
    Num.Nonnegative(k,"turbulent kinetic energy"); Num.Positive(epsilon,"dissipation rate"); Cmu=Cmu or 0.09
    return Cmu*k*k/epsilon
end
function Module.TurbulentKineticEnergy(uPrime,vPrime,wPrime)
    return 0.5*(uPrime*uPrime+vPrime*vPrime+wPrime*wPrime)
end

return Module
