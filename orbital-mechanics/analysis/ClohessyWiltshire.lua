-- orbital-mechanics implementation for ClohessyWiltshire
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Propagate(state,n,t)
    assert(#state==6,"CW state must be [x,y,z,xdot,ydot,zdot]"); Num.Positive(n,"mean motion"); Num.Nonnegative(t,"time")
    local x,y,z,xd,yd,zd=table.unpack(state); local c=math.cos(n*t); local s=math.sin(n*t)
    return { (4-3*c)*x+s/n*xd+2*(1-c)/n*yd,
        6*(s-n*t)*x+y-2*(1-c)/n*xd+(4*s-3*n*t)/n*yd,
        c*z+s/n*zd,
        3*n*s*x+c*xd+2*s*yd,
        6*n*(c-1)*x-2*s*xd+(4*c-3)*yd,
        -n*s*z+c*zd }
end

return Module
