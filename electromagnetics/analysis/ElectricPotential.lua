-- electromagnetics implementation for ElectricPotential
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.PointCharges(charges,positions,observation)
    assert(#charges==#positions,"charge and position count mismatch")
    local potential=0
    for i=1,#charges do local r=LA.Norm(Num.Subtract(observation,positions[i])); Num.Positive(r,"charge separation"); potential+=charges[i]/r end
    return potential/(4*math.pi*Constants.EPSILON_0)
end

return Module
