-- rigid-body-physics implementation for QuaternionKinematics
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local Lie = require(VectorForge:WaitForChild("LieGroupKinematics"))

local Module = {}
function Module.IntegrateOrientation(q,angularVelocity,dt)
    Num.Nonnegative(dt,"time step"); assert(#angularVelocity==3,"angular velocity must have three components")
    local magnitude=LA.Norm(angularVelocity); local half=magnitude*dt/2
    local delta=if magnitude<1e-14 then Lie.Quaternion.New(1,0,0,0) else Lie.Quaternion.New(math.cos(half),angularVelocity[1]/magnitude*math.sin(half),angularVelocity[2]/magnitude*math.sin(half),angularVelocity[3]/magnitude*math.sin(half))
    return Lie.Quaternion.Normalize(Lie.Quaternion.Multiply(q,delta))
end

return Module
