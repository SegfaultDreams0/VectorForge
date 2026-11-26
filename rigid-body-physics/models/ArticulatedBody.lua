-- rigid-body-physics implementation for ArticulatedBody
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.PlanarForwardKinematics(lengths,angles)
    assert(#lengths==#angles,"joint/link count mismatch"); local x,y,theta=0,0,0; local joints={{0,0}}
    for i=1,#lengths do Num.Positive(lengths[i],"link length"); theta+=angles[i]; x+=lengths[i]*math.cos(theta); y+=lengths[i]*math.sin(theta); joints[i+1]={x,y} end
    return joints,{X=x,Y=y,Angle=theta}
end

return Module
