-- rigid-body-physics implementation for RotationMatrix
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local Lie = require(VectorForge:WaitForChild("LieGroupKinematics"))

local Module = {}
function Module.FromQuaternion(q)
    local Q=Lie.Quaternion.Normalize(q); local w,x,y,z=Q.W,Q.X,Q.Y,Q.Z
    return {{1-2*(y*y+z*z),2*(x*y-z*w),2*(x*z+y*w)},{2*(x*y+z*w),1-2*(x*x+z*z),2*(y*z-x*w)},{2*(x*z-y*w),2*(y*z+x*w),1-2*(x*x+y*y)}}
end

return Module
