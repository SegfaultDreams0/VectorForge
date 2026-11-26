-- rigid-body-physics implementation for ConstraintSolver
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ProjectedGaussSeidel(A,b,initial,iterations,lower,upper)
    local x=table.clone(initial); local n=#b; assert(#A==n and #x==n,"constraint system dimension mismatch")
    for _=1,(iterations or 100) do
        for i=1,n do
            local sigma=0; for j=1,n do if j~=i then sigma+=A[i][j]*x[j] end end
            local candidate=(b[i]-sigma)/A[i][i]
            if lower then candidate=math.max(lower[i],candidate) end
            if upper then candidate=math.min(upper[i],candidate) end
            x[i]=candidate
        end
    end
    return x,LA.Norm(Num.Subtract(LA.MatrixVector(A,x),b))
end

return Module
