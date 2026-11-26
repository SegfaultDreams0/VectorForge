-- quantum-mechanics implementation for VonNeumannEvolution
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.Derivative(H,rho)
    local commutator=Num.Subtract(LA.Multiply(H,rho),LA.Multiply(rho,H))
    return {Real=LA.Zeros(#H,#H),Imaginary=Num.Scale(commutator,-1/Constants.HBAR)}
end

return Module
