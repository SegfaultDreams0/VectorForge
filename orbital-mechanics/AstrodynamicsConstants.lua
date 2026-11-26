-- orbital-mechanics implementation for AstrodynamicsConstants
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.MeanMotion(mu,a)
    Num.Positive(mu,"mu"); Num.Positive(a,"semi-major axis"); return math.sqrt(mu/a^3)
end
function Module.EarthCircularPeriod(a)
    return 2*math.pi*math.sqrt(a^3/Constants.EARTH_MU)
end

return Module
