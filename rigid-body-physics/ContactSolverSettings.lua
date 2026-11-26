-- rigid-body-physics implementation for ContactSolverSettings
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Validate(settings)
    assert(settings.Iterations>=1 and settings.Iterations%1==0,"iterations must be a positive integer")
    Num.Nonnegative(settings.Friction,"friction"); assert(settings.Restitution>=0 and settings.Restitution<=1,"restitution must be in [0,1]")
    return true
end

return Module
