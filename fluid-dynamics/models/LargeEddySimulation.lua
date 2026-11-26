-- fluid-dynamics implementation for LargeEddySimulation
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.SmagorinskyViscosity(strainTensor,filterWidth,Cs)
    Num.Positive(filterWidth,"filter width"); Cs=Cs or 0.17
    local magnitude=math.sqrt(2)*LA.FrobeniusNorm(strainTensor)
    return (Cs*filterWidth)^2*magnitude
end

return Module
