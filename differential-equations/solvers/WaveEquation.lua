-- differential-equations implementation for WaveEquation
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Leapfrog(previous,current,waveSpeed,dx,dt)
    Num.Nonnegative(waveSpeed,"wave speed"); Num.Positive(dx,"grid spacing"); Num.Positive(dt,"time step")
    local courant=waveSpeed*dt/dx; assert(courant<=1,"1D wave equation CFL condition violated")
    local nextField=table.clone(current); local r=courant*courant
    for i=2,#current-1 do nextField[i]=2*current[i]-previous[i]+r*(current[i+1]-2*current[i]+current[i-1]) end
    return nextField
end

return Module
