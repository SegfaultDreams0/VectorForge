-- orbital-mechanics implementation for BiEllipticTransfer
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.DeltaV(mu,r1,r2,rb)
    Num.Positive(mu,"gravitational parameter"); Num.Positive(r1,"initial radius"); Num.Positive(r2,"final radius"); Num.Positive(rb,"intermediate apoapsis")
    assert(rb>=math.max(r1,r2),"intermediate apoapsis must exceed both circular radii")
    local a1=(r1+rb)/2; local a2=(r2+rb)/2
    local v1=math.sqrt(mu/r1); local v2=math.sqrt(mu/r2)
    local vp1=math.sqrt(mu*(2/r1-1/a1)); local va1=math.sqrt(mu*(2/rb-1/a1))
    local va2=math.sqrt(mu*(2/rb-1/a2)); local vp2=math.sqrt(mu*(2/r2-1/a2))
    return {Burn1=vp1-v1,Burn2=va2-va1,Burn3=v2-vp2,Total=math.abs(vp1-v1)+math.abs(va2-va1)+math.abs(v2-vp2)}
end

return Module
