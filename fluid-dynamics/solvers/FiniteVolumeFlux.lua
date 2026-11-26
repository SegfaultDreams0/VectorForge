-- fluid-dynamics implementation for FiniteVolumeFlux
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Rusanov(leftState,rightState,leftFlux,rightFlux,maxWaveSpeed)
    assert(#leftState==#rightState and #leftFlux==#leftState and #rightFlux==#rightState,"finite-volume state mismatch")
    Num.Nonnegative(maxWaveSpeed,"maximum wave speed")
    local flux=table.create(#leftState)
    for i=1,#flux do flux[i]=0.5*(leftFlux[i]+rightFlux[i])-0.5*maxWaveSpeed*(rightState[i]-leftState[i]) end
    return flux
end

return Module
