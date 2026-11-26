-- quantum-mechanics implementation for BarrierTunneling
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.Transmission(E,V0,width,mass,hbar)
    Num.Positive(E,"particle energy"); Num.Positive(V0,"barrier height"); Num.Positive(width,"barrier width"); Num.Positive(mass,"mass"); hbar=hbar or Constants.HBAR
    if math.abs(E-V0)<=1e-12*math.max(E,V0) then
        return 1/(1+mass*V0*width*width/(2*hbar*hbar))
    elseif E>V0 then
        local k2=math.sqrt(2*mass*(E-V0))/hbar
        local denominator=1+(V0*V0*math.sin(k2*width)^2)/(4*E*(E-V0))
        return 1/denominator
    end
    local kappa=math.sqrt(2*mass*(V0-E))/hbar
    local denominator=1+(V0*V0*math.sinh(kappa*width)^2)/(4*E*(V0-E))
    return 1/denominator
end


-- Log-domain under-barrier transmission prevents overflow for thick barriers.
-- T = [1 + V0^2 sinh^2(kappa a)/(4 E (V0-E))]^-1, kappa=sqrt(2m(V0-E))/hbar.
function Module.LogTransmission(E, V0, width, mass, hbar)
    Num.Positive(E, "particle energy"); Num.Positive(V0, "barrier height")
    Num.Positive(width, "barrier width"); Num.Positive(mass, "particle mass")
    local h = hbar or Constants.HBAR
    Num.Positive(h, "reduced Planck constant")
    if E >= V0 then
        local transmission = Module.Transmission(E, V0, width, mass, h)
        return math.log(math.max(transmission, 1e-300))
    end
    local kappa = math.sqrt(2 * mass * (V0 - E)) / h
    local x = kappa * width
    local logSinh
    if x < 20 then logSinh = math.log(math.sinh(x)) else logSinh = x - math.log(2) + math.log(1 - math.exp(-2*x)) end
    local logTerm = 2 * math.log(V0) + 2 * logSinh - math.log(4 * E * (V0 - E))
    local logDenominator = math.max(0, logTerm) + math.log(1 + math.exp(-math.abs(logTerm)))
    return -logDenominator
end

function Module.Reflection(E, V0, width, mass, hbar)
    local transmission = Module.Transmission(E, V0, width, mass, hbar)
    return 1 - transmission
end

return Module
