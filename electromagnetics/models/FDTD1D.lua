-- electromagnetics implementation for FDTD1D
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.StepElectric(E,H,dt,dx,epsilon)
    Num.Positive(dt,"dt"); Num.Positive(dx,"dx"); Num.Positive(epsilon,"epsilon")
    local out=table.clone(E)
    for i=1,#E-1 do out[i]+=dt/(epsilon*dx)*(H[i+1]-H[i]) end
    return out
end
function Module.StepMagnetic(H,E,dt,dx,mu)
    Num.Positive(dt,"dt"); Num.Positive(dx,"dx"); Num.Positive(mu,"mu")
    local out=table.clone(H)
    for i=2,#H do out[i]+=dt/(mu*dx)*(E[i]-E[i-1]) end
    return out
end


-- Courant number S = c*dt/dx; the 1D Yee scheme requires S <= 1 in vacuum.
function Module.CourantNumber(timeStep, spacing, waveSpeed)
    Num.Positive(timeStep,"time step"); Num.Positive(spacing,"grid spacing"); Num.Positive(waveSpeed,"wave speed")
    return waveSpeed*timeStep/spacing
end

-- Discrete 1D field energy density, integrated by the trapezoidal rule.
function Module.EnergyElectricMagnetic(electric, magnetic, spacing, epsilon, permeability)
    Num.Positive(spacing,"grid spacing"); Num.Positive(epsilon,"permittivity"); Num.Positive(permeability,"permeability")
    assert(#electric==#magnetic and #electric>=2,"field arrays must have matching lengths")
    local total=0
    for i=1,#electric do
        local weight=(i==1 or i==#electric) and 0.5 or 1
        total += weight*(0.5*epsilon*electric[i]^2+0.5*magnetic[i]^2/permeability)
    end
    return total*spacing
end

return Module
