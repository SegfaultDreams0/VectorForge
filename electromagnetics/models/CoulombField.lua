-- electromagnetics implementation for CoulombField
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.PointCharge(charge,position,observation)
    local displacement=Num.Subtract(observation,position); local radius=LA.Norm(displacement); Num.Positive(radius,"distance")
    return Num.Scale(displacement,charge/(4*math.pi*Constants.EPSILON_0*radius^3))
end

return Module
