local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
-- orbital-mechanics implementation for KeplerEquation
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.

local Module = {}
function Module.Solve(meanAnomaly,eccentricity,tolerance,maxIterations)
    assert(eccentricity>=0 and eccentricity<1,"elliptic eccentricity must be in [0,1)")
    local E=meanAnomaly; local tol=tolerance or 1e-12
    for iteration=1,(maxIterations or 50) do
        local f=E-eccentricity*math.sin(E)-meanAnomaly
        local delta=f/(1-eccentricity*math.cos(E)); E-=delta
        if math.abs(delta)<tol then return E,{Converged=true,Iterations=iteration,Residual=math.abs(f)} end
    end
    return E,{Converged=false,Iterations=maxIterations or 50,Residual=math.abs(E-eccentricity*math.sin(E)-meanAnomaly)}
end


-- Convert eccentric anomaly to true anomaly for an elliptic orbit.
function Module.TrueAnomaly(eccentricAnomaly, eccentricity)
    assert(eccentricity>=0 and eccentricity<1,"elliptic eccentricity must lie in [0,1)")
    local y=math.sqrt(1-eccentricity^2)*math.sin(eccentricAnomaly)
    local x=math.cos(eccentricAnomaly)-eccentricity
    return math.atan2(y,x)
end

-- Mean motion n=sqrt(mu/a^3), period P=2 pi/n.
function Module.Period(semiMajorAxis, gravitationalParameter)
    Num.Positive(semiMajorAxis,"semi-major axis"); Num.Positive(gravitationalParameter,"gravitational parameter")
    return 2*math.pi*math.sqrt(semiMajorAxis^3/gravitationalParameter)
end

function Module.MeanMotion(semiMajorAxis, gravitationalParameter)
    return 2*math.pi/Module.Period(semiMajorAxis,gravitationalParameter)
end

return Module
