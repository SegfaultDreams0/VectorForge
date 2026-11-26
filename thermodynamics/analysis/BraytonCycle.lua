-- thermodynamics implementation for BraytonCycle
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Efficiency(pressureRatio,gamma)
    Num.Positive(pressureRatio,"pressure ratio"); assert(pressureRatio>=1,"pressure ratio must be >= 1"); assert(gamma>1,"gamma must exceed one")
    return 1-pressureRatio^(-(gamma-1)/gamma)
end
function Module.TemperatureAfterCompression(T1,pressureRatio,gamma)
    Num.Positive(T1,"inlet temperature"); return T1*pressureRatio^((gamma-1)/gamma)
end


-- Complete ideal-gas Brayton cycle with non-isentropic compressor/turbine efficiencies.
-- SI: temperatures K, cp J/(kg K), specific work J/kg, pressures Pa.
function Module.Analyze(inletTemperature, turbineInletTemperature, pressureRatio, gamma, cp, compressorEfficiency, turbineEfficiency)
    Num.Positive(inletTemperature, "compressor inlet temperature")
    assert(turbineInletTemperature > inletTemperature, "turbine inlet temperature must exceed compressor inlet")
    assert(pressureRatio > 1 and gamma > 1 and cp > 0, "invalid Brayton cycle properties")
    local etaC = compressorEfficiency or 1
    local etaT = turbineEfficiency or 1
    assert(etaC > 0 and etaC <= 1 and etaT > 0 and etaT <= 1, "component efficiencies must lie in (0,1]")
    local exponent = (gamma - 1) / gamma
    local t2s = inletTemperature * pressureRatio ^ exponent
    local t2 = inletTemperature + (t2s - inletTemperature) / etaC
    local t4s = turbineInletTemperature / pressureRatio ^ exponent
    local t4 = turbineInletTemperature - etaT * (turbineInletTemperature - t4s)
    assert(turbineInletTemperature > t2, "turbine inlet temperature must exceed compressor discharge")
    local compressorWork = cp * (t2 - inletTemperature)
    local turbineWork = cp * (turbineInletTemperature - t4)
    local heatAdded = cp * (turbineInletTemperature - t2)
    local heatRejected = cp * (t4 - inletTemperature)
    local netWork = turbineWork - compressorWork
    return {
        T2 = t2, T4 = t4,
        CompressorWork = compressorWork, TurbineWork = turbineWork,
        NetWork = netWork, HeatAdded = heatAdded, HeatRejected = heatRejected,
        BackWorkRatio = compressorWork / turbineWork,
        Efficiency = netWork / heatAdded,
        EnergyBalanceResidual = heatAdded - heatRejected - netWork,
    }
end

-- Ideal Brayton pressure ratio for maximum net specific work at fixed T1 and T3.
function Module.OptimumPressureRatio(T1, T3, gamma)
    Num.Positive(T1, "minimum cycle temperature"); Num.Positive(T3, "maximum cycle temperature")
    assert(T3 > T1 and gamma > 1, "invalid optimum-pressure-ratio inputs")
    return (T3 / T1) ^ (gamma / (2 * (gamma - 1)))
end

return Module
