-- orbital-mechanics implementation for OrbitalElements
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.FromState(r,v,mu)
    Num.Positive(mu,"mu"); local rn=LA.Norm(r); Num.Positive(rn,"radius"); local h=Num.Cross3(r,v); local hn=LA.Norm(h); Num.Positive(hn,"specific angular momentum")
    local n=Num.Cross3({0,0,1},h); local nn=LA.Norm(n); local evec=Num.Subtract(Num.Scale(Num.Cross3(v,h),1/mu),Num.Scale(r,1/rn)); local e=LA.Norm(evec)
    local energy=LA.Dot(v,v)/2-mu/rn; local a=if math.abs(energy)<1e-14 then math.huge else -mu/(2*energy)
    local inc=math.acos(math.max(-1,math.min(1,h[3]/hn)))
    local raan=if nn>1e-12 then math.atan2(n[2],n[1]) else 0
    local argp=if nn>1e-12 and e>1e-12 then math.atan2(LA.Dot(Num.Cross3(n,evec),h)/(nn*e*hn),LA.Dot(n,evec)/(nn*e)) else 0
    local nu=if e>1e-12 then math.atan2(LA.Dot(Num.Cross3(evec,r),h)/(e*rn*hn),LA.Dot(evec,r)/(e*rn)) else math.atan2(r[2],r[1])
    return {a=a,e=e,i=inc,raan=raan,argp=argp,nu=nu,AngularMomentum=hn,SpecificEnergy=energy}
end

return Module
