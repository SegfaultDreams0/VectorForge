-- rigid-body-physics implementation for CollisionResponse
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.NormalImpulse(relativeVelocity,normal,inverseMassA,inverseMassB,restitution)
    assert(restitution>=0 and restitution<=1,"restitution outside [0,1]"); Num.Nonnegative(inverseMassA,"inverse mass A"); Num.Nonnegative(inverseMassB,"inverse mass B")
    local denominator=inverseMassA+inverseMassB; Num.Positive(denominator,"inverse mass sum")
    local closing=LA.Dot(relativeVelocity,normal)
    if closing>=0 then return 0 end
    return -(1+restitution)*closing/denominator
end

return Module
