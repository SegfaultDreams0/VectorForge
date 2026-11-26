-- control-systems implementation for StateSpaceDefinition
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Validate(A,B,C,D)
    local n,m=LA.Dimensions(A); assert(n==m,"A must be square")
    assert(#B==n and #C[1]==n and #D==#C,"state-space matrix dimensions inconsistent")
    assert(#B[1]==#D[1],"B and D input dimensions mismatch")
    return {States=n,Inputs=#B[1],Outputs=#C}
end

return Module
