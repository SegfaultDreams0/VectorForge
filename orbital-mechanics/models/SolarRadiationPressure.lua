-- orbital-mechanics implementation for SolarRadiationPressure
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Acceleration(area,mass,reflectivity,distanceAU)
    Num.Positive(area,"area"); Num.Positive(mass,"mass"); assert(reflectivity>=0 and reflectivity<=2,"reflectivity coefficient out of range"); Num.Positive(distanceAU,"distance in AU")
    local pressure=4.56e-6/(distanceAU^2)
    return pressure*reflectivity*area/mass
end

return Module
