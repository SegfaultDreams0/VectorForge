-- computational-geometry implementation for SurfaceParameterization
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Barycentric3D(point,triangle)
    local v0=Num.Subtract(triangle[2],triangle[1]); local v1=Num.Subtract(triangle[3],triangle[1]); local v2=Num.Subtract(point,triangle[1])
    local d00=LA.Dot(v0,v0); local d01=LA.Dot(v0,v1); local d11=LA.Dot(v1,v1); local d20=LA.Dot(v2,v0); local d21=LA.Dot(v2,v1)
    local denominator=d00*d11-d01*d01; Num.Positive(math.abs(denominator),"triangle metric determinant")
    local v=(d11*d20-d01*d21)/denominator; local w=(d00*d21-d01*d20)/denominator
    return {1-v-w,v,w}
end
function Module.MapTriangle(point,worldTriangle,uvTriangle)
    local weights=Module.Barycentric3D(point,worldTriangle); local uv={0,0}
    for i=1,3 do uv[1]+=weights[i]*uvTriangle[i][1]; uv[2]+=weights[i]*uvTriangle[i][2] end
    return uv,weights
end

return Module
