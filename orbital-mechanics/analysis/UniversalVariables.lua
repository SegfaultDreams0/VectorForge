-- orbital-mechanics implementation for UniversalVariables
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Propagate(r0,v0,dt,mu)
    Num.Positive(mu,"mu"); Num.Nonnegative(math.abs(dt),"absolute propagation time"); assert(#r0==3 and #v0==3,"3D state required")
    local r0n=LA.Norm(r0); Num.Positive(r0n,"initial radius")
    local sqrtMu=math.sqrt(mu); local vr0=LA.Dot(r0,v0)/r0n; local alpha=2/r0n-LA.Dot(v0,v0)/mu
    local chi=sqrtMu*math.abs(alpha)*dt
    if math.abs(alpha)<1e-8 then chi=sqrtMu*dt/r0n end
    local converged=false
    for _=1,100 do
        local z=alpha*chi*chi; local C=Num.StumpffC(z); local S=Num.StumpffS(z)
        local F=r0n*vr0/sqrtMu*chi*chi*C+(1-alpha*r0n)*chi^3*S+r0n*chi-sqrtMu*dt
        local dF=r0n*vr0/sqrtMu*chi*(1-z*S)+(1-alpha*r0n)*chi*chi*C+r0n
        local step=F/dF; chi-=step
        if math.abs(step)<1e-10 then converged=true; break end
    end
    assert(converged,"universal anomaly did not converge")
    local z=alpha*chi*chi; local C=Num.StumpffC(z); local S=Num.StumpffS(z)
    local f=1-chi*chi/r0n*C; local g=dt-chi^3/sqrtMu*S
    local r=Num.Add(Num.Scale(r0,f),Num.Scale(v0,g)); local rn=LA.Norm(r)
    local fdot=sqrtMu/(rn*r0n)*(alpha*chi^3*S-chi); local gdot=1-chi*chi/rn*C
    local v=Num.Add(Num.Scale(r0,fdot),Num.Scale(v0,gdot))
    return r,v
end

return Module
