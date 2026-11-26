-- computational-geometry implementation for TriangleIntersection
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.RayMollerTrumbore(origin,direction,triangle,tolerance)
    local eps=tolerance or 1e-10; local v0,v1,v2=triangle[1],triangle[2],triangle[3]
    local edge1=Num.Subtract(v1,v0); local edge2=Num.Subtract(v2,v0); local h=Num.Cross3(direction,edge2); local a=LA.Dot(edge1,h)
    if math.abs(a)<eps then return nil end
    local f=1/a; local s=Num.Subtract(origin,v0); local u=f*LA.Dot(s,h); if u<0 or u>1 then return nil end
    local q=Num.Cross3(s,edge1); local v=f*LA.Dot(direction,q); if v<0 or u+v>1 then return nil end
    local t=f*LA.Dot(edge2,q); if t<eps then return nil end
    return t,{u=u,v=v,w=1-u-v},Num.Add(origin,Num.Scale(direction,t))
end

return Module
