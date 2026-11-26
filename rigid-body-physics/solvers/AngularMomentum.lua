-- rigid-body-physics implementation for AngularMomentum
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Compute(inertia,angularVelocity)
    return LA.MatrixVector(inertia,angularVelocity)
end
function Module.Magnitude(inertia,angularVelocity)
    return LA.Norm(Module.Compute(inertia,angularVelocity))
end

return Module
