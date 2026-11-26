-- orbital-mechanics implementation for J2Perturbation
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Acceleration(position,mu,radius,J2)
    Num.Positive(mu,"mu"); Num.Positive(radius,"reference radius"); local r=LA.Norm(position); Num.Positive(r,"radius")
    local z2=position[3]^2; local factor=1.5*J2*mu*radius^2/(r^5); local q=5*z2/(r*r)
    return {factor*position[1]*(q-1),factor*position[2]*(q-1),factor*position[3]*(q-3)}
end

return Module
