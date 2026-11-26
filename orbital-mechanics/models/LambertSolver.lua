-- orbital-mechanics implementation for LambertSolver
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}

function Module.ZeroRevolution(r1, r2, deltaTime, mu, prograde)
    Num.Positive(deltaTime, "transfer time")
    Num.Positive(mu, "gravitational parameter")
    assert(#r1 == 3 and #r2 == 3, "position vectors must have three components")
    local r1n, r2n = LA.Norm(r1), LA.Norm(r2)
    Num.Positive(r1n, "initial radius")
    Num.Positive(r2n, "final radius")
    local cosine = math.max(-1, math.min(1, LA.Dot(r1, r2) / (r1n * r2n)))
    local cross = Num.Cross3(r1, r2)
    assert(math.abs(cross[3]) > 1e-12, "transfer plane must define a non-ambiguous reference-z direction")
    local sineMagnitude = LA.Norm(cross) / (r1n * r2n)
    local sine = sineMagnitude
    if (prograde ~= false and cross[3] < 0) or (prograde == false and cross[3] > 0) then
        sine = -sineMagnitude
    end
    local denominator = 1 - cosine
    Num.Positive(denominator, "Lambert transfer geometry")
    local A = sine * math.sqrt(r1n * r2n / denominator)
    assert(math.abs(A) > 1e-12, "Lambert geometry is singular")

    local function evaluate(z)
        local C = Num.StumpffC(z)
        local S = Num.StumpffS(z)
        if C <= 0 then return nil, math.huge end
        local y = r1n + r2n + A * (z * S - 1) / math.sqrt(C)
        if y <= 0 then return y, math.huge end
        local time = ((y / C) ^ 1.5 * S + A * math.sqrt(y)) / math.sqrt(mu)
        return y, time
    end

    local lo, hi = 0, 0
    local _, timeAtZero = evaluate(0)
    if timeAtZero > deltaTime then
        hi = 0
        lo = -1
        local _, tlo = evaluate(lo)
        local expansions = 0
        while tlo > deltaTime and expansions < 80 do
            lo *= 2
            _, tlo = evaluate(lo)
            expansions += 1
        end
        assert(tlo <= deltaTime, "could not bracket a hyperbolic Lambert solution")
    else
        lo = 0
        hi = 1
        local _, thi = evaluate(hi)
        local upperLimit = (2 * math.pi) ^ 2 - 1e-7
        while (thi < deltaTime or thi == math.huge) and hi < upperLimit do
            hi = math.min(2 * hi, upperLimit)
            _, thi = evaluate(hi)
            if thi == math.huge and hi >= upperLimit then break end
        end
        assert(thi >= deltaTime and thi < math.huge, "could not bracket an elliptic Lambert solution")
    end

    local z, y = 0, 0
    for _ = 1, 120 do
        z = 0.5 * (lo + hi)
        local transferTime
        y, transferTime = evaluate(z)
        if transferTime > deltaTime then
            hi = z
        else
            lo = z
        end
        if math.abs(transferTime - deltaTime) <= 1e-10 * math.max(deltaTime, 1) then break end
    end

    local _, solvedTime = evaluate(z)
    assert(math.abs(solvedTime - deltaTime) <= 1e-7 * math.max(deltaTime, 1), "Lambert universal-variable iteration did not converge")
    local f = 1 - y / r1n
    local g = A * math.sqrt(y / mu)
    local gdot = 1 - y / r2n
    assert(math.abs(g) > 1e-12, "Lambert Lagrange coefficient is singular")
    local v1 = Num.Scale(Num.Subtract(r2, Num.Scale(r1, f)), 1 / g)
    local v2 = Num.Scale(Num.Subtract(Num.Scale(r2, gdot), r1), 1 / g)
    return v1, v2, {UniversalVariable = z, TransferTime = solvedTime}
end

return Module
