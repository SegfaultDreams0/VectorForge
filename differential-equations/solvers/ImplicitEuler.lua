-- differential-equations implementation for ImplicitEuler
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local AD = require(VectorForge:WaitForChild("AutomaticDifferentiation"))

local Module = {}
function Module.Step(state,dt,derivative,initialGuess)
    Num.Positive(dt,"step size"); local x=table.clone(initialGuess or state)
    for iteration=1,30 do
        local function residual(candidate) return Num.Subtract(candidate,Num.Add(state,Num.Scale(derivative(candidate),dt))) end
        local r=residual(x); local norm=LA.Norm(r)
        if norm<1e-10 then return x,{Converged=true,Iterations=iteration,Residual=norm} end
        local J=AD.Jacobian(residual,x); local delta,reason=LA.Solve(J,Num.Scale(r,-1)); assert(delta,reason or "implicit Euler Jacobian solve failed"); x=Num.Add(x,delta)
    end
    return x,{Converged=false,Reason="Newton iteration limit"}
end

return Module
