-- orbital-mechanics implementation for GaussVariational
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ElementRates(a,e,i,nu,mu,radial,transverse,normal)
    Num.Positive(a,"semi-major axis"); Num.Positive(mu,"mu"); assert(e>=0 and e<1,"elliptic eccentricity required")
    local p=a*(1-e*e); local h=math.sqrt(mu*p); local u=nu
    local radius=p/(1+e*math.cos(u))
    local da=2*a*a/h*(e*math.sin(u)*radial+(p/radius)*transverse)
    local de=(p*math.sin(u)*radial+((p+radius)*math.cos(u)+radius*e)*transverse)/h
    local di=(radius*math.cos(u)/h)*normal
    return {SemiMajorAxis=da,Eccentricity=de,Inclination=di}
end

return Module
