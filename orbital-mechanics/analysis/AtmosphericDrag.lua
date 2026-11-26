-- orbital-mechanics implementation for AtmosphericDrag
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Acceleration(velocity,density,dragCoefficient,area,mass)
    Num.Nonnegative(density,"atmospheric density"); Num.Nonnegative(dragCoefficient,"drag coefficient"); Num.Nonnegative(area,"reference area"); Num.Positive(mass,"mass")
    local speed=LA.Norm(velocity); if speed==0 then return {0,0,0} end
    return Num.Scale(velocity,-0.5*density*dragCoefficient*area*speed/mass)
end

return Module
