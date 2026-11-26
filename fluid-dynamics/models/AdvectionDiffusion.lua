-- fluid-dynamics implementation for AdvectionDiffusion
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step1D(field,velocity,diffusivity,dx,dt)
    Num.Nonnegative(diffusivity,"diffusivity"); Num.Positive(dx,"grid spacing"); Num.Positive(dt,"time step")
    local courant=math.abs(velocity)*dt/dx; local diffusionNumber=diffusivity*dt/(dx*dx)
    assert(courant+2*diffusionNumber<=1,"explicit advection-diffusion stability limit exceeded")
    local out=table.clone(field)
    for i=2,#field-1 do
        local adv=if velocity>=0 then velocity*(field[i]-field[i-1])/dx else velocity*(field[i+1]-field[i])/dx
        out[i]=field[i]-dt*adv+diffusivity*dt*(field[i+1]-2*field[i]+field[i-1])/(dx*dx)
    end
    return out
end

return Module
