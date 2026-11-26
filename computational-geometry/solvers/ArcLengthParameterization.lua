local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
-- computational-geometry implementation for ArcLengthParameterization
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.IntegrateSpeed(derivative,a,b,segments)
    local n=segments or 100; if n%2==1 then n+=1 end; local h=(b-a)/n; local sum=LA.Norm(derivative(a))+LA.Norm(derivative(b))
    for i=1,n-1 do sum+=(if i%2==0 then 2 else 4)*LA.Norm(derivative(a+i*h)) end
    return sum*h/3
end
function Module.BuildTable(derivative,parameters)
    local cumulative=table.create(#parameters,0)
    for i=2,#parameters do cumulative[i]=cumulative[i-1]+Module.IntegrateSpeed(derivative,parameters[i-1],parameters[i],20) end
    return cumulative
end


-- Invert a monotone (parameter, cumulative length) table with binary search.
function Module.ParameterAtLength(tableData,targetLength)
    assert(#tableData>=2,"arc-length table requires at least two entries")
    assert(targetLength>=tableData[1].Length and targetLength<=tableData[#tableData].Length,"target length outside table")
    local low,high=1,#tableData
    while high-low>1 do
        local middle=math.floor((low+high)/2)
        if tableData[middle].Length<=targetLength then low=middle else high=middle end
    end
    local left,right=tableData[low],tableData[high]
    local span=right.Length-left.Length
    assert(span>0,"arc-length table must be strictly increasing")
    local fraction=(targetLength-left.Length)/span
    return left.Parameter+fraction*(right.Parameter-left.Parameter)
end

-- Curvature-based sampling density: ds <= sqrt(8*tolerance/|kappa|).
function Module.CurvatureStep(curvature,geometricTolerance,maximumStep)
    Num = Num or require(game:GetService("ReplicatedStorage"):WaitForChild("VectorForgeShared"):WaitForChild("NumericalKernels"))
    Num.Nonnegative(curvature,"curvature"); Num.Positive(geometricTolerance,"geometric tolerance"); Num.Positive(maximumStep,"maximum step")
    if curvature<=1e-14 then return maximumStep end
    return math.min(maximumStep,math.sqrt(8*geometricTolerance/curvature))
end

return Module
