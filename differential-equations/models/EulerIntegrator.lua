-- differential-equations implementation for EulerIntegrator
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step(f,time,state,dt)
    Num.Positive(dt,"time step"); return Num.Add(state,Num.Scale(f(state,time),dt))
end

return Module
