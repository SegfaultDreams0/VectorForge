-- orbital-mechanics implementation for StateToElements
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("OrbitalMechanics")
local OrbitalElements = require(DomainModules:WaitForChild("models"):WaitForChild("OrbitalElements"))

local Module = {}
function Module.Convert(position,velocity,mu)
    return OrbitalElements.FromState(position,velocity,mu)
end

return Module
