-- rigid-body-physics implementation for InverseKinematics
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.PlanarTwoLink(x,y,l1,l2,elbowUp)
    Num.Positive(l1,"link length 1"); Num.Positive(l2,"link length 2")
    local cosine=(x*x+y*y-l1*l1-l2*l2)/(2*l1*l2)
    assert(cosine>=-1-1e-10 and cosine<=1+1e-10,"target is outside two-link workspace")
    cosine=math.max(-1,math.min(1,cosine)); local q2=(if elbowUp then 1 else -1)*math.acos(cosine)
    local q1=math.atan2(y,x)-math.atan2(l2*math.sin(q2),l1+l2*math.cos(q2))
    return {q1,q2}
end

return Module
