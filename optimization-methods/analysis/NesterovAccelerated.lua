-- optimization-methods implementation for NesterovAccelerated
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step(x,previous,gradient,L,iteration)
    Num.Positive(L,"Lipschitz constant"); assert(iteration>=1,"iteration must be positive")
    local momentum=(iteration-1)/(iteration+2)
    local extrapolated=Num.Add(x,Num.Scale(Num.Subtract(x,previous),momentum))
    return Num.Subtract(extrapolated,Num.Scale(gradient,1/L)),extrapolated
end

return Module
