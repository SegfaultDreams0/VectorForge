-- rigid-body-physics implementation for ContactConstraint
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.BaumgarteImpulse(velocityAlongNormal,penetration,dt,effectiveMass,beta,restitution)
    Num.Positive(dt,"time step"); Num.Positive(effectiveMass,"effective mass"); Num.Nonnegative(beta,"Baumgarte coefficient"); assert(restitution>=0 and restitution<=1,"restitution outside [0,1]")
    local bias=beta*math.max(penetration,0)/dt
    return math.max(0,-(1+restitution)*velocityAlongNormal/effectiveMass+bias/effectiveMass)
end

return Module
