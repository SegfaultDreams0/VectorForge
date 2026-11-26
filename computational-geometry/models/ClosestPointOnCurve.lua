-- computational-geometry implementation for ClosestPointOnCurve
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.GoldenSection(evaluate,target,lower,upper,tolerance)
    local ratio=(math.sqrt(5)-1)/2; local a,b=lower,upper; local c=b-ratio*(b-a); local d=a+ratio*(b-a)
    local function distance2(t) return LA.Dot(Num.Subtract(evaluate(t),target),Num.Subtract(evaluate(t),target)) end
    while b-a>(tolerance or 1e-8) do
        if distance2(c)<distance2(d) then b=d; d=c; c=b-ratio*(b-a) else a=c; c=d; d=a+ratio*(b-a) end
    end
    local parameter=(a+b)/2; local point=evaluate(parameter); return parameter,point,math.sqrt(distance2(parameter))
end

return Module
