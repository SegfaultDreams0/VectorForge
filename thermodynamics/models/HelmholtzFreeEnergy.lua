-- thermodynamics implementation for HelmholtzFreeEnergy
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.FromInternalEnergy(U,T,S)
    Num.Positive(T,"temperature"); return U-T*S
end

return Module
