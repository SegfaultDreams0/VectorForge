-- computational-geometry implementation for SignedDistanceField
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Polygon(point,vertices)
    assert(#vertices>=3,"polygon requires at least three vertices"); local minimum=math.huge; local inside=false
    for i=1,#vertices do
        local a=vertices[i]; local b=vertices[i%#vertices+1]; local ab=Num.Subtract(b,a); local ap=Num.Subtract(point,a)
        local t=math.max(0,math.min(1,LA.Dot(ap,ab)/math.max(LA.Dot(ab,ab),1e-30)))
        local closest=Num.Add(a,Num.Scale(ab,t)); minimum=math.min(minimum,LA.Norm(Num.Subtract(point,closest)))
        if ((a[2]>point[2])~=(b[2]>point[2])) and (point[1]<(b[1]-a[1])*(point[2]-a[2])/(b[2]-a[2])+a[1]) then inside=not inside end
    end
    return if inside then -minimum else minimum
end

return Module
