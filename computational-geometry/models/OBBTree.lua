-- computational-geometry implementation for OBBTree
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Intersects(a,b)
    local R=LA.Zeros(3,3); local AbsR=LA.Zeros(3,3)
    for i=1,3 do for j=1,3 do R[i][j]=LA.Dot(a.Axes[i],b.Axes[j]); AbsR[i][j]=math.abs(R[i][j])+1e-9 end end
    local delta=Num.Subtract(b.Center,a.Center); local t={LA.Dot(delta,a.Axes[1]),LA.Dot(delta,a.Axes[2]),LA.Dot(delta,a.Axes[3])}
    for i=1,3 do local ra=a.HalfExtents[i]; local rb=b.HalfExtents[1]*AbsR[i][1]+b.HalfExtents[2]*AbsR[i][2]+b.HalfExtents[3]*AbsR[i][3]; if math.abs(t[i])>ra+rb then return false end end
    for j=1,3 do local ra=a.HalfExtents[1]*AbsR[1][j]+a.HalfExtents[2]*AbsR[2][j]+a.HalfExtents[3]*AbsR[3][j]; local rb=b.HalfExtents[j]; local projected=math.abs(t[1]*R[1][j]+t[2]*R[2][j]+t[3]*R[3][j]); if projected>ra+rb then return false end end
    for i=1,3 do for j=1,3 do
        local i1=i%3+1; local i2=(i+1)%3+1; local j1=j%3+1; local j2=(j+1)%3+1
        local ra=a.HalfExtents[i1]*AbsR[i2][j]+a.HalfExtents[i2]*AbsR[i1][j]
        local rb=b.HalfExtents[j1]*AbsR[i][j2]+b.HalfExtents[j2]*AbsR[i][j1]
        local projected=math.abs(t[i2]*R[i1][j]-t[i1]*R[i2][j])
        if projected>ra+rb then return false end
    end end
    return true
end

return Module
