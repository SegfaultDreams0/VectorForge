-- orbital-mechanics implementation for CowellIntegrator
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Propagate(state,dt,steps,acceleration,mu)
    assert(#state==6,"Cowell state must contain position and velocity")
    local function rhs(x)
        local r={x[1],x[2],x[3]}; local v={x[4],x[5],x[6]}; local a=acceleration(r,v)
        local rn=LA.Norm(r); Num.Positive(rn,"orbital radius")
        local central=Num.Scale(r,-mu/rn^3); local total=Num.Add(central,a)
        return {v[1],v[2],v[3],total[1],total[2],total[3]}
    end
    local current=table.clone(state); for step=1,steps do current=Num.RK4(rhs,current,(step-1)*dt,dt) end
    return current
end

return Module
