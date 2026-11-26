-- thermodynamics implementation for ConvectionCorrelation
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.DittusBoelter(Re,Pr,heating)
    assert(Re>=10000,"Dittus-Boelter requires turbulent pipe flow Re >= 10000"); Num.Positive(Pr,"Prandtl number")
    return 0.023*Re^0.8*Pr^(if heating then 0.4 else 0.3)
end

return Module
