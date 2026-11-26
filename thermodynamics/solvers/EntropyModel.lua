-- thermodynamics implementation for EntropyModel
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.IdealGasChange(moles,cv,T1,T2,V1,V2)
    Num.Nonnegative(moles,"moles"); Num.Positive(cv,"Cv"); Num.Positive(T1,"T1"); Num.Positive(T2,"T2"); Num.Positive(V1,"V1"); Num.Positive(V2,"V2")
    return moles*(cv*math.log(T2/T1)+Constants.R*math.log(V2/V1))
end

return Module
