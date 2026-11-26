-- differential-equations implementation for VerletIntegrator
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step(position,velocity,acceleration,dt)
    Num.Positive(dt,"time step"); local a0=acceleration(position)
    local nextPosition=Num.Add(position,Num.Add(Num.Scale(velocity,dt),Num.Scale(a0,0.5*dt*dt)))
    local a1=acceleration(nextPosition)
    local nextVelocity=Num.Add(velocity,Num.Scale(Num.Add(a0,a1),0.5*dt))
    return nextPosition,nextVelocity
end

return Module
