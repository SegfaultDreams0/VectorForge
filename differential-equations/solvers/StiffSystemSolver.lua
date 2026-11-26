-- differential-equations implementation for StiffSystemSolver
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.RosenbrockEuler(state,time,dt,derivative,jacobian,gamma)
    Num.Positive(dt,"time step"); gamma=gamma or 1
    local f=derivative(state,time); local J=jacobian(state,time); local A=Num.Subtract(LA.Identity(#state),Num.Scale(J,gamma*dt))
    local increment,reason=LA.Solve(A,Num.Scale(f,dt)); assert(increment,reason or "Rosenbrock linear solve failed")
    return Num.Add(state,increment)
end

return Module
