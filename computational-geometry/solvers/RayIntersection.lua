-- computational-geometry implementation for RayIntersection
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.RaySegment2D(origin,direction,a,b)
    local segment=Num.Subtract(b,a); local denominator=direction[1]*segment[2]-direction[2]*segment[1]
    if math.abs(denominator)<1e-12 then return nil end
    local delta=Num.Subtract(a,origin); local t=(delta[1]*segment[2]-delta[2]*segment[1])/denominator
    local u=(delta[1]*direction[2]-delta[2]*direction[1])/denominator
    if t>=0 and u>=0 and u<=1 then return t,u,Num.Add(origin,Num.Scale(direction,t)) end
    return nil
end

return Module
