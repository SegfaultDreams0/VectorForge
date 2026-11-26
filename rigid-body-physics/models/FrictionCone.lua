-- rigid-body-physics implementation for FrictionCone
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Project(normalImpulse,tangentImpulse,frictionCoefficient)
    Num.Nonnegative(normalImpulse,"normal impulse"); Num.Nonnegative(frictionCoefficient,"friction coefficient")
    local limit=frictionCoefficient*normalImpulse; local magnitude=LA.Norm(tangentImpulse)
    if magnitude<=limit or magnitude==0 then return table.clone(tangentImpulse) end
    return Num.Scale(tangentImpulse,limit/magnitude)
end

return Module
