-- computational-geometry implementation for GeometricTolerance
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ForScale(scale,relative)
    Num.Nonnegative(scale,"geometry scale"); return math.max(1e-12,scale*(relative or 1e-9))
end
function Module.IsNear(a,b,tolerance) return math.abs(a-b)<=tolerance end

return Module
