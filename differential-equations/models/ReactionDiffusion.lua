-- differential-equations implementation for ReactionDiffusion
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.GrayScottStep(U,V,Du,Dv,feed,kill,dt,dx)
    assert(#U==#V,"Gray-Scott fields must have equal size"); Num.Nonnegative(Du,"Du"); Num.Nonnegative(Dv,"Dv"); Num.Nonnegative(feed,"feed rate"); Num.Nonnegative(kill,"kill rate"); Num.Positive(dx,"dx")
    local uNext=table.clone(U); local vNext=table.clone(V)
    for i=2,#U-1 do
        local lapU=(U[i-1]-2*U[i]+U[i+1])/(dx*dx); local lapV=(V[i-1]-2*V[i]+V[i+1])/(dx*dx); local reaction=U[i]*V[i]*V[i]
        uNext[i]=U[i]+dt*(Du*lapU-reaction+feed*(1-U[i]))
        vNext[i]=V[i]+dt*(Dv*lapV+reaction-(feed+kill)*V[i])
    end
    return uNext,vNext
end

return Module
