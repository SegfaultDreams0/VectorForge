-- rigid-body-physics implementation for ImpulseResolution
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.OneDimensional(vA,vB,mA,mB,restitution)
    Num.Positive(mA,"mass A"); Num.Positive(mB,"mass B"); assert(restitution>=0 and restitution<=1,"restitution outside [0,1]")
    local relative=vA-vB; local impulse=-(1+restitution)*relative/(1/mA+1/mB)
    return vA+impulse/mA,vB-impulse/mB,impulse
end

return Module
