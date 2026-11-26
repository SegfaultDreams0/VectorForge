-- differential-equations implementation for HeatEquation
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ExplicitStep(temperature,alpha,dx,dt)
    Num.Nonnegative(alpha,"thermal diffusivity"); Num.Positive(dx,"grid spacing"); Num.Positive(dt,"time step")
    local r=alpha*dt/(dx*dx); assert(r<=0.5,"explicit heat equation requires alpha*dt/dx^2 <= 0.5")
    local nextT=table.clone(temperature)
    for i=2,#temperature-1 do nextT[i]=temperature[i]+r*(temperature[i+1]-2*temperature[i]+temperature[i-1]) end
    return nextT
end

return Module
