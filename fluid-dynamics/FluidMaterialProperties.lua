-- fluid-dynamics implementation for FluidMaterialProperties
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.KinematicViscosity(dynamicViscosity,density)
    Num.Nonnegative(dynamicViscosity,"dynamic viscosity"); Num.Positive(density,"density")
    return dynamicViscosity/density
end
function Module.ReynoldsNumber(density,speed,length,dynamicViscosity)
    Num.Positive(density,"density"); Num.Nonnegative(speed,"speed"); Num.Positive(length,"characteristic length"); Num.Positive(dynamicViscosity,"dynamic viscosity")
    return density*speed*length/dynamicViscosity
end

return Module
