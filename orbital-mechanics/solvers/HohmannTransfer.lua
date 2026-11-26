-- orbital-mechanics implementation for HohmannTransfer
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.DeltaV(mu,r1,r2)
    Num.Positive(mu,"mu"); Num.Positive(r1,"initial orbit radius"); Num.Positive(r2,"final orbit radius")
    local at=(r1+r2)/2; local v1=math.sqrt(mu/r1); local v2=math.sqrt(mu/r2)
    local vt1=math.sqrt(mu*(2/r1-1/at)); local vt2=math.sqrt(mu*(2/r2-1/at))
    return {Departure=vt1-v1,Arrival=v2-vt2,Total=math.abs(vt1-v1)+math.abs(v2-vt2),TransferTime=math.pi*math.sqrt(at^3/mu)}
end

return Module
