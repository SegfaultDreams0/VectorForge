-- rigid-body-physics implementation for ForwardKinematics
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.SerialDH(parameters)
    local transform=LA.Identity(4)
    for _,joint in ipairs(parameters) do
        local ct,st=math.cos(joint.theta),math.sin(joint.theta); local ca,sa=math.cos(joint.alpha),math.sin(joint.alpha)
        local A={{ct,-st*ca,st*sa,joint.a*ct},{st,ct*ca,-ct*sa,joint.a*st},{0,sa,ca,joint.d},{0,0,0,1}}
        transform=LA.Multiply(transform,A)
    end
    return transform
end

return Module
