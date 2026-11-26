-- thermodynamics implementation for VanDerWaalsEOS
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.Pressure(n,T,V,a,b)
    Num.Nonnegative(n,"moles"); Num.Positive(T,"temperature"); Num.Positive(V,"volume"); Num.Nonnegative(a,"attraction parameter"); Num.Nonnegative(b,"covolume")
    assert(V>n*b,"volume must exceed n*b")
    return n*Constants.R*T/(V-n*b)-a*n*n/(V*V)
end


-- Critical constants for one mole: Tc=8a/(27Rb), Pc=a/(27b^2), Vc=3b.
function Module.CriticalPoint(a, b, gasConstant)
    Num.Positive(a, "attraction parameter"); Num.Positive(b, "co-volume parameter")
    local R = gasConstant or Constants.R
    Num.Positive(R, "gas constant")
    return {Temperature = 8 * a / (27 * R * b), Pressure = a / (27 * b * b), MolarVolume = 3 * b}
end

-- Analytic pressure derivatives at fixed n and T/V variables.
function Module.Derivatives(n, temperature, volume, a, b, gasConstant)
    Num.Positive(n, "amount"); Num.Positive(temperature, "temperature"); Num.Positive(volume, "volume")
    assert(a >= 0 and b >= 0 and volume > n * b, "state must satisfy V > n b and nonnegative a,b")
    local R = gasConstant or Constants.R
    local dpdT = n * R / (volume - n * b)
    local dpdV = -n * R * temperature / ((volume - n * b) ^ 2) + 2 * a * n * n / (volume ^ 3)
    return dpdT, dpdV
end

-- Compressibility factor Z = PV/(nRT), a useful dimensionless state diagnostic.
function Module.CompressibilityFactor(n, temperature, volume, a, b, gasConstant)
    local pressure = Module.Pressure(n, temperature, volume, a, b, gasConstant)
    local R = gasConstant or Constants.R
    return pressure * volume / (n * R * temperature)
end

return Module
