-- electromagnetics implementation for PoyntingVector
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Compute(electricField,magneticField)
    return Num.Cross3(electricField,magneticField)
end
function Module.Magnitude(electricField,magneticField)
    return LA.Norm(Module.Compute(electricField,magneticField))
end

return Module
