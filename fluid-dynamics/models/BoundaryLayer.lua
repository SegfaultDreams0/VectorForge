-- fluid-dynamics implementation for BoundaryLayer
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.BlasiusThickness(x,ReynoldsX)
    Num.Positive(x,"distance from leading edge"); Num.Positive(ReynoldsX,"local Reynolds number")
    return 5*x/math.sqrt(ReynoldsX)
end
function Module.SkinFriction(ReynoldsX)
    Num.Positive(ReynoldsX,"local Reynolds number"); return 0.664/math.sqrt(ReynoldsX)
end

return Module
