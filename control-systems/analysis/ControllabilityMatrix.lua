-- control-systems implementation for ControllabilityMatrix
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Build(A,B)
    local n=#A; assert(#B==n,"A/B row mismatch"); local blocks={}; local power=LA.Identity(n)
    for i=1,n do table.insert(blocks,LA.Multiply(power,B)); power=LA.Multiply(power,A) end
    local columns=#B[1]; local C=LA.Zeros(n,n*columns)
    for block=1,#blocks do for i=1,n do for j=1,columns do C[i][(block-1)*columns+j]=blocks[block][i][j] end end end
    return C,LA.Rank(C)
end

return Module
