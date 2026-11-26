-- rigid-body-physics implementation for RigidBodyParameters
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Validate(mass,inertia)
    Num.Positive(mass,"mass"); assert(#inertia==3 and #inertia[1]==3,"inertia tensor must be 3x3")
    assert(LA.Determinant(inertia)>0,"inertia tensor must be positive definite")
    return {Mass=mass,Inertia=LA.Copy(inertia)}
end

return Module
