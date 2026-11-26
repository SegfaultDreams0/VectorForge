-- control-systems implementation for PolePlacement
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("ControlSystems")
local ControllabilityMatrix = require(DomainModules:WaitForChild("analysis"):WaitForChild("ControllabilityMatrix"))

local Module = {}
function Module.Ackermann(A,B,poles)
    local n=#A; assert(n<=6 and #B==n and #B[1]==1 and #poles==n,"Ackermann implementation supports SISO systems of order 1..6")
    local C,rank=ControllabilityMatrix.Build(A,B); assert(rank==n,"system is not controllable")
    local coefficients={1}
    for _,pole in ipairs(poles) do
        local nextC=table.create(#coefficients+1,0)
        for i=1,#coefficients do nextC[i]+=coefficients[i]; nextC[i+1]-=pole*coefficients[i] end
        coefficients=nextC
    end
    local polynomial=Num.Scale(LA.Identity(n),coefficients[1]); local power=LA.Identity(n)
    for degree=1,n do power=LA.Multiply(power,A); polynomial=Num.Add(polynomial,Num.Scale(power,coefficients[degree+1])) end
    local inverse=LA.Inverse(C); assert(inverse,"controllability matrix singular")
    local selector=LA.Zeros(1,n); selector[1][n]=1
    return LA.Multiply(LA.Multiply(selector,inverse),polynomial)
end

return Module
