-- orbital-mechanics implementation for ElementsToState
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Convert(elements,mu)
    Num.Positive(mu,"gravitational parameter"); local a,e,i,raan,argp,nu=elements.a,elements.e,elements.i,elements.raan,elements.argp,elements.nu
    Num.Positive(a,"semi-major axis"); assert(e>=0 and e<1,"elliptic conversion requires 0<=e<1")
    local p=a*(1-e*e); local r=p/(1+e*math.cos(nu)); local h=math.sqrt(mu*p)
    local rp={r*math.cos(nu),r*math.sin(nu),0}; local vp={-mu/h*math.sin(nu),mu/h*(e+math.cos(nu)),0}
    local co,so,ci,si,cw,sw=math.cos(raan),math.sin(raan),math.cos(i),math.sin(i),math.cos(argp),math.sin(argp)
    local R={{co*cw-so*sw*ci,-co*sw-so*cw*ci,so*si},{so*cw+co*sw*ci,-so*sw+co*cw*ci,-co*si},{sw*si,cw*si,ci}}
    return LA.MatrixVector(R,rp),LA.MatrixVector(R,vp)
end

return Module
