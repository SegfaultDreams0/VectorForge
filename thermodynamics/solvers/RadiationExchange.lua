-- thermodynamics implementation for RadiationExchange
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.NetPower(emissivity,area,T1,T2,viewFactor)
    assert(emissivity>=0 and emissivity<=1,"emissivity must be in [0,1]"); Num.Positive(area,"area"); Num.Positive(T1,"T1"); Num.Positive(T2,"T2")
    assert(viewFactor>=0 and viewFactor<=1,"view factor must be in [0,1]")
    return emissivity*Constants.SIGMA_SB*area*viewFactor*(T1^4-T2^4)
end

return Module
