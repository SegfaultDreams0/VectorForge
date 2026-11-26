-- fluid-dynamics implementation for ShallowWater
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Flux(depth,momentum,gravity)
    Num.Nonnegative(depth,"water depth"); Num.Positive(gravity,"gravity")
    if depth==0 then return {0,0} end
    local velocity=momentum/depth
    return {momentum,momentum*velocity+0.5*gravity*depth*depth}
end
function Module.WaveSpeed(depth,gravity)
    Num.Nonnegative(depth,"water depth"); Num.Positive(gravity,"gravity")
    return math.sqrt(gravity*depth)
end

return Module
