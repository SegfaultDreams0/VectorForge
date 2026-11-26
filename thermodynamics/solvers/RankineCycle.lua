-- thermodynamics implementation for RankineCycle
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ThermalEfficiency(hBoilerOut,hTurbineOut,hPumpOut,hCondenserOut)
    local turbineWork=hBoilerOut-hTurbineOut; local pumpWork=hPumpOut-hCondenserOut
    local heatInput=hBoilerOut-hPumpOut
    Num.Positive(heatInput,"heat input")
    return (turbineWork-pumpWork)/heatInput
end

return Module
