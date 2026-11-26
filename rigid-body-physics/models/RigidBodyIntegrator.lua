-- rigid-body-physics implementation for RigidBodyIntegrator
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.SemiImplicit(position,velocity,mass,force,dt)
    Num.Positive(mass,"mass"); Num.Positive(dt,"time step")
    local nextVelocity=Num.Add(velocity,Num.Scale(force,dt/mass))
    return Num.Add(position,Num.Scale(nextVelocity,dt)),nextVelocity
end

return Module
