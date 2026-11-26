-- computational-geometry implementation for CatmullRomSpline
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Evaluate(p0,p1,p2,p3,t,tension)
    local tau=tension or 0.5; local t2=t*t; local t3=t2*t
    local a=Num.Scale(p1,2); local b=Num.Scale(Num.Subtract(p2,p0),tau)
    local c=Num.Add(Num.Add(Num.Scale(p0,2),Num.Scale(p1,-5)),Num.Add(Num.Scale(p2,4),Num.Scale(p3,-1)))
    local d=Num.Add(Num.Add(Num.Scale(p0,-1),Num.Scale(p1,3)),Num.Add(Num.Scale(p2,-3),p3))
    return Num.Scale(Num.Add(Num.Add(a,Num.Scale(b,t)),Num.Add(Num.Scale(c,t2),Num.Scale(d,t3))),0.5)
end

return Module
