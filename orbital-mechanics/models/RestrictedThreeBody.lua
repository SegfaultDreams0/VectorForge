-- orbital-mechanics implementation for RestrictedThreeBody
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Acceleration(position,velocity,muRatio)
    assert(muRatio>0 and muRatio<0.5,"mass ratio must be in (0,0.5)")
    local x,y,z=position[1],position[2],position[3]; local r1=math.sqrt((x+muRatio)^2+y*y+z*z); local r2=math.sqrt((x-1+muRatio)^2+y*y+z*z)
    Num.Positive(r1,"primary distance"); Num.Positive(r2,"secondary distance")
    return {2*velocity[2]+x-(1-muRatio)*(x+muRatio)/r1^3-muRatio*(x-1+muRatio)/r2^3,
        -2*velocity[1]+y-(1-muRatio)*y/r1^3-muRatio*y/r2^3,
        -(1-muRatio)*z/r1^3-muRatio*z/r2^3}
end

return Module
