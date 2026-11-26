-- computational-geometry implementation for BSplineCurve
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Evaluate(controlPoints,degree,knots,u)
    assert(degree>=0 and degree<#controlPoints,"invalid B-spline degree"); assert(#knots==#controlPoints+degree+1,"knot vector dimension mismatch")
    local span=degree+1
    for i=degree+1,#controlPoints do if u>=knots[i] and u<knots[i+1] then span=i; break end end
    if u==knots[#knots] then span=#controlPoints end
    local d=table.create(degree+1)
    for j=0,degree do d[j+1]=table.clone(controlPoints[span-degree+j]) end
    for r=1,degree do for j=degree,r,-1 do local index=span-degree+j; local denominator=knots[index+degree-r+1]-knots[index]; local alpha=if denominator==0 then 0 else (u-knots[index])/denominator; d[j+1]=Num.Add(Num.Scale(d[j],1-alpha),Num.Scale(d[j+1],alpha)) end end
    return d[degree+1]
end

return Module
