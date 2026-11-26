-- fluid-dynamics implementation for HydrostaticBalance
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.PressureAtDepth(surfacePressure,density,gravity,depth)
    Num.Positive(density,"density"); Num.Positive(gravity,"gravity"); Num.Nonnegative(depth,"depth")
    return surfacePressure+density*gravity*depth
end

return Module
