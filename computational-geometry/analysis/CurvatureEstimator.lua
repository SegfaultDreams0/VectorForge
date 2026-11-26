-- computational-geometry implementation for CurvatureEstimator
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ThreePoint2D(a,b,c)
    local ab=LA.Norm(Num.Subtract(b,a)); local bc=LA.Norm(Num.Subtract(c,b)); local ca=LA.Norm(Num.Subtract(a,c))
    Num.Positive(ab*bc*ca,"triangle side product")
    local twiceArea=math.abs((b[1]-a[1])*(c[2]-a[2])-(b[2]-a[2])*(c[1]-a[1]))
    return 2*twiceArea/(ab*bc*ca)
end
function Module.FromDerivatives(first,second)
    local cross=Num.Cross3(first,second); local speed=LA.Norm(first); Num.Positive(speed,"curve speed")
    return LA.Norm(cross)/(speed^3)
end

return Module
