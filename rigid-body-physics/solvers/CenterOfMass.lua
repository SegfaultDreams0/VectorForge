-- rigid-body-physics implementation for CenterOfMass
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("RigidBodyPhysics")
local MassProperties = require(DomainModules:WaitForChild("models"):WaitForChild("MassProperties"))

local Module = {}
function Module.FromBodies(masses,centers)
    local center,total=MassProperties.CenterOfMass(masses,centers)
    return center,total
end

return Module
