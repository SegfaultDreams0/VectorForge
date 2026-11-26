-- rigid-body-physics implementation for InertiaTensor
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.PointMasses(masses,positions,center)
    assert(#masses==#positions and #masses>0,"mass/position count mismatch"); local I=LA.Zeros(3,3)
    for i=1,#masses do Num.Nonnegative(masses[i],"point mass"); local r=Num.Subtract(positions[i],center); local r2=LA.Dot(r,r)
        for row=1,3 do for col=1,3 do I[row][col]+=masses[i]*((if row==col then r2 else 0)-r[row]*r[col]) end end
    end
    return I
end

return Module
