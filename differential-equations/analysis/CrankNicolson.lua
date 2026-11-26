-- differential-equations implementation for CrankNicolson
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.LinearStep(A,state,dt)
    Num.Positive(dt,"time step"); local I=LA.Identity(#state)
    local left=Num.Subtract(I,Num.Scale(A,dt/2)); local right=LA.MatrixVector(Num.Add(I,Num.Scale(A,dt/2)),state)
    local result,reason=LA.Solve(left,right); assert(result,reason or "Crank-Nicolson solve failed"); return result
end

return Module
