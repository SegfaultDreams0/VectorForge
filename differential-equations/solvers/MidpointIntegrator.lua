-- differential-equations implementation for MidpointIntegrator
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ExplicitStep(f,time,state,dt)
    Num.Positive(dt,"step size"); local first=f(state,time); local midpoint=Num.Add(state,Num.Scale(first,dt/2))
    return Num.Add(state,Num.Scale(f(midpoint,time+dt/2),dt))
end

return Module
