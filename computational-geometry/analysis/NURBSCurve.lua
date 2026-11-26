-- computational-geometry implementation for NURBSCurve
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Basis(i,p,u,knots)
    if p==0 then return if (knots[i]<=u and u<knots[i+1]) or (u==knots[#knots] and i==#knots-p-1) then 1 else 0 end
    local left=0; local right=0; local d1=knots[i+p]-knots[i]; local d2=knots[i+p+1]-knots[i+1]
    if d1>0 then left=(u-knots[i])/d1*Module.Basis(i,p-1,u,knots) end
    if d2>0 then right=(knots[i+p+1]-u)/d2*Module.Basis(i+1,p-1,u,knots) end
    return left+right
end
function Module.Evaluate(controlPoints,weights,degree,knots,u)
    assert(#controlPoints==#weights,"NURBS control point/weight mismatch"); Num.Positive(#controlPoints,"control point count")
    local dimension=#controlPoints[1]; local numerator=table.create(dimension,0); local denominator=0
    for i=1,#controlPoints do local basis=Module.Basis(i,degree,u,knots)*weights[i]; denominator+=basis; numerator=Num.Add(numerator,Num.Scale(controlPoints[i],basis)) end
    Num.Positive(math.abs(denominator),"NURBS rational denominator")
    return Num.Scale(numerator,1/denominator)
end


-- Rational curve denominator and a scale-aware singularity diagnostic.
function Module.WeightSum(basis,weights)
    assert(#basis==#weights,"basis and weight count mismatch")
    local denominator=0
    for i=1,#basis do
        assert(weights[i]>=0,"NURBS weights must be nonnegative")
        denominator+=basis[i]*weights[i]
    end
    return denominator
end

-- Evaluate rational basis functions R_i=N_i*w_i/sum_j(N_j*w_j).
function Module.RationalBasis(basis,weights,tolerance)
    local denominator=Module.WeightSum(basis,weights)
    assert(math.abs(denominator)>(tolerance or 1e-12),"NURBS rational denominator is singular")
    local rational=table.create(#basis)
    for i=1,#basis do rational[i]=basis[i]*weights[i]/denominator end
    return rational,denominator
end

return Module
