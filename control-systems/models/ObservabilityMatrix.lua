-- control-systems implementation for ObservabilityMatrix
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Build(A,C)
    local n=#A; assert(#C[1]==n,"C column count must equal state dimension"); local O=LA.Zeros(n*#C,#A); local power=LA.Identity(n)
    for block=1,n do
        local product=LA.Multiply(C,power)
        for i=1,#C do for j=1,n do O[(block-1)*#C+i][j]=product[i][j] end end
        power=LA.Multiply(power,A)
    end
    return O,LA.Rank(O)
end

return Module
