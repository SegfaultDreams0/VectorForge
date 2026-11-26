-- rigid-body-physics implementation for NewtonEuler6DOF
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("RigidBodyPhysics")
local EulerRigidBody = require(DomainModules:WaitForChild("analysis"):WaitForChild("EulerRigidBody"))

local Module = {}
function Module.Derivative(mass,inertia,linearVelocity,angularVelocity,force,torque)
    Num.Positive(mass,"mass"); local acceleration=Num.Scale(force,1/mass)
    local angularAcceleration=EulerRigidBody.AngularAcceleration(inertia,angularVelocity,torque)
    return {PositionRate=table.clone(linearVelocity),VelocityRate=acceleration,AngularVelocityRate=angularAcceleration}
end

return Module
