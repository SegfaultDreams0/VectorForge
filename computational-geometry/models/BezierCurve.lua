-- computational-geometry implementation for BezierCurve
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Evaluate(controlPoints,t)
    assert(#controlPoints>=2 and t>=0 and t<=1,"invalid Bezier input")
    local work={}; for i,p in ipairs(controlPoints) do work[i]=table.clone(p) end
    for level=#work-1,1,-1 do for i=1,level do work[i]=Num.Add(Num.Scale(work[i],1-t),Num.Scale(work[i+1],t)) end end
    return work[1]
end
function Module.DerivativeControlPoints(controlPoints)
    local degree=#controlPoints-1; assert(degree>=1,"Bezier curve degree must be at least one")
    local result=table.create(degree)
    for i=1,degree do result[i]=Num.Scale(Num.Subtract(controlPoints[i+1],controlPoints[i]),degree) end
    return result
end

return Module
