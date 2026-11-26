-- rigid-body-physics implementation for MassProperties
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.CenterOfMass(masses,positions)
    assert(#masses==#positions and #masses>0,"mass and position count mismatch"); local total=0; local center={0,0,0}
    for i=1,#masses do Num.Nonnegative(masses[i],"mass"); total+=masses[i]; center=Num.Add(center,Num.Scale(positions[i],masses[i])) end
    Num.Positive(total,"total mass"); return Num.Scale(center,1/total),total
end

return Module
