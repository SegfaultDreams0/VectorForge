-- fluid-dynamics implementation for LatticeBoltzmann
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.D2Q9Equilibrium(rho,ux,uy)
    Num.Positive(rho,"density")
    local c={{0,0},{1,0},{0,1},{-1,0},{0,-1},{1,1},{-1,1},{-1,-1},{1,-1}}
    local w={4/9,1/9,1/9,1/9,1/9,1/36,1/36,1/36,1/36}
    local eq=table.create(9); local u2=ux*ux+uy*uy
    for i=1,9 do local cu=c[i][1]*ux+c[i][2]*uy; eq[i]=w[i]*rho*(1+3*cu+4.5*cu*cu-1.5*u2) end
    return eq
end
function Module.BGKCollision(populations,rho,ux,uy,omega)
    assert(#populations==9 and omega>0 and omega<2,"D2Q9 BGK requires 0<omega<2")
    local eq=Module.D2Q9Equilibrium(rho,ux,uy); local out=table.create(9)
    for i=1,9 do out[i]=populations[i]-omega*(populations[i]-eq[i]) end
    return out
end


-- Recover density and momentum from D2Q9 populations using the standard lattice velocities.
function Module.MacroscopicMoments(populations)
    assert(#populations == 9, "D2Q9 requires nine populations")
    local c = {{0,0},{1,0},{0,1},{-1,0},{0,-1},{1,1},{-1,1},{-1,-1},{1,-1}}
    local rho, mx, my = 0, 0, 0
    for i = 1, 9 do
        assert(populations[i] >= 0, "population must be nonnegative")
        rho += populations[i]
        mx += populations[i] * c[i][1]
        my += populations[i] * c[i][2]
    end
    Num.Positive(rho, "lattice density")
    return rho, mx/rho, my/rho
end

-- Kinematic viscosity for BGK relaxation: nu = cs^2 (tau - 1/2) dt, cs^2=1/3.
function Module.ViscosityFromRelaxationTime(tau, latticeTimeStep)
    Num.Positive(latticeTimeStep, "lattice time step")
    assert(tau > 0.5, "BGK relaxation time must exceed one half")
    return (tau - 0.5) * latticeTimeStep / 3
end

-- Check local equilibrium mass and momentum conservation.
function Module.EquilibriumMoments(rho, ux, uy)
    local populations = Module.D2Q9Equilibrium(rho, ux, uy)
    local recoveredDensity, recoveredX, recoveredY = Module.MacroscopicMoments(populations)
    return {
        DensityResidual = recoveredDensity-rho,
        MomentumXResidual = recoveredDensity*recoveredX-rho*ux,
        MomentumYResidual = recoveredDensity*recoveredY-rho*uy,
    }
end

return Module
