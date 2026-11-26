-- thermodynamics implementation for PengRobinsonEOS
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.Pressure(n,T,V,acentric,Tc,Pc)
    Num.Positive(n,"moles"); Num.Positive(T,"temperature"); Num.Positive(V,"volume"); Num.Positive(Tc,"critical temperature"); Num.Positive(Pc,"critical pressure")
    local kappa=0.37464+1.54226*acentric-0.26992*acentric^2
    local alpha=(1+kappa*(1-math.sqrt(T/Tc)))^2
    local am=0.45724*Constants.R^2*Tc^2/Pc*alpha
    local bm=0.07780*Constants.R*Tc/Pc
    local molar=V/n; assert(molar>bm,"molar volume must exceed Peng-Robinson covolume")
    return Constants.R*T/(molar-bm)-am/(molar*(molar+bm)+bm*(molar-bm))
end


-- Dimensionless Peng-Robinson parameters A and B for a pure component.
function Module.DimensionlessParameters(temperature, pressure, criticalTemperature, criticalPressure, acentricFactor, gasConstant)
    Num.Positive(temperature, "temperature"); Num.Positive(pressure, "pressure")
    Num.Positive(criticalTemperature, "critical temperature"); Num.Positive(criticalPressure, "critical pressure")
    local R = gasConstant or Constants.R
    local Tr = temperature / criticalTemperature
    local kappa = 0.37464 + 1.54226 * acentricFactor - 0.26992 * acentricFactor * acentricFactor
    local alpha = (1 + kappa * (1 - math.sqrt(Tr))) ^ 2
    local a = 0.45724 * R * R * criticalTemperature * criticalTemperature / criticalPressure
    local b = 0.07780 * R * criticalTemperature / criticalPressure
    return a * alpha * pressure / (R * R * temperature * temperature), b * pressure / (R * temperature), alpha, a, b
end

-- Cubic coefficients for the compressibility-factor equation.
function Module.CubicCoefficients(A, B)
    assert(A >= 0 and B > 0, "Peng-Robinson requires A >= 0 and B > 0")
    return {1, -(1 - B), A - 3 * B * B - 2 * B, -(A * B - B * B - B * B * B)}
end

return Module
