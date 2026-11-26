-- rigid-body-physics implementation for GyroscopicCoupling
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Torque(omega,inertia)
    local angularMomentum=LA.MatrixVector(inertia,omega)
    return Num.Cross3(omega,angularMomentum)
end

return Module
