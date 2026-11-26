-- fluid-dynamics implementation for SmoothedParticleHydro
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Poly6Kernel(distance,h)
    Num.Positive(h,"smoothing length"); if distance<0 or distance>=h then return 0 end
    local factor=315/(64*math.pi*h^9); return factor*(h*h-distance*distance)^3
end
function Module.SpikyGradient(distance,h)
    Num.Positive(h,"smoothing length"); if distance<=0 or distance>=h then return 0 end
    return -45/(math.pi*h^6)*(h-distance)^2
end

return Module
