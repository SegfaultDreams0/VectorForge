-- computational-geometry implementation for TorsionEstimator
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.FromDerivatives(first,second,third)
    local cross=Num.Cross3(first,second); local denominator=LA.Dot(cross,cross); Num.Positive(denominator,"curvature cross-product norm")
    return LA.Dot(cross,third)/denominator
end

return Module
