-- differential-equations implementation for AdamsBashforth
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step2(y,fNow,fPrevious,dt)
    Num.Positive(dt,"step size"); assert(#y==#fNow and #y==#fPrevious,"state dimension mismatch")
    return Num.Add(y,Num.Scale(Num.Subtract(Num.Scale(fNow,3),fPrevious),dt/2))
end
function Module.Step3(y,fNow,f1,f2,dt)
    Num.Positive(dt,"step size"); return Num.Add(y,Num.Scale(Num.Add(Num.Subtract(Num.Scale(fNow,23),Num.Scale(f1,16)),Num.Scale(f2,5)),dt/12))
end

return Module
