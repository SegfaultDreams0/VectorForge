-- differential-equations implementation for SymplecticEuler
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step(position,velocity,acceleration,dt)
    Num.Positive(dt,"step size"); local nextVelocity=Num.Add(velocity,Num.Scale(acceleration(position),dt))
    return Num.Add(position,Num.Scale(nextVelocity,dt)),nextVelocity
end

return Module
