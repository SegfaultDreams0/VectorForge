-- quantum-mechanics implementation for QuantumFourierTransform
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Forward(signal)
    local n=#signal; local out=table.create(n)
    for k=0,n-1 do
        local sum={Re=0,Im=0}
        for j=0,n-1 do
            local phase=-2*math.pi*j*k/n
            sum=Num.ComplexAdd(sum,Num.ComplexMul(signal[j+1],Num.ComplexExp(phase)))
        end
        out[k+1]=sum
    end
    return out
end

return Module
