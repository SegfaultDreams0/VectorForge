-- control-systems implementation for LinearStateSpace
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Derivative(A,B,state,input)
    return Num.Add(LA.MatrixVector(A,state),LA.MatrixVector(B,input))
end
function Module.Output(C,D,state,input)
    return Num.Add(LA.MatrixVector(C,state),LA.MatrixVector(D,input))
end


-- Zero-order-hold discrete transition for a scalar first-order mode xdot=a*x+b*u.
function Module.DiscretizeScalar(a,b,dt)
    assert(type(a)=="number" and type(b)=="number" and dt>0,"invalid scalar state-space parameters")
    local Ad=math.exp(a*dt)
    local Bd=math.abs(a)<1e-12 and b*dt or b*(Ad-1)/a
    return Ad,Bd
end

-- Simulate a linear state-space model with a constant input over one interval.
function Module.Step(A,B,state,input,dt)
    local derivative=Module.Derivative(A,B,state,input)
    return Num.Add(state,Num.Scale(derivative,dt))
end

return Module
