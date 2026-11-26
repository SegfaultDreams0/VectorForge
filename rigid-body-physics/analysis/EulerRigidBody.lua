-- rigid-body-physics implementation for EulerRigidBody
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.AngularAcceleration(inertia,omega,torque)
    local momentum=LA.MatrixVector(inertia,omega); local gyroscopic=Num.Cross3(omega,momentum)
    local rhs=Num.Subtract(torque,gyroscopic); local acceleration,reason=LA.Solve(inertia,rhs); assert(acceleration,reason or "inertia tensor singular")
    return acceleration
end


-- Rotational kinetic energy T=1/2 omega^T I omega and angular momentum L=I omega.
function Module.EnergyAndMomentum(inertia,angularVelocity)
    assert(#angularVelocity==3 and #inertia==3,"rigid body requires three dimensions")
    local momentum=LA.MatrixVector(inertia,angularVelocity)
    return 0.5*LA.Dot(angularVelocity,momentum),momentum
end

-- Euler equation in body coordinates: I omega_dot = tau - omega x (I omega).
function Module.AngularAccelerationWithTorque(inertia,angularVelocity,torque)
    assert(#torque==3 and #angularVelocity==3,"torque and angular velocity must be 3D")
    local momentum=LA.MatrixVector(inertia,angularVelocity)
    local gyroscopic=Num.Cross3(angularVelocity,momentum)
    local rhs=Num.Subtract(torque,gyroscopic)
    local acceleration,reason=LA.Solve(inertia,rhs)
    assert(acceleration,reason or "inertia solve failed")
    return acceleration
end

return Module
