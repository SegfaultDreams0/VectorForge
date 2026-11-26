-- quantum-mechanics implementation for HamiltonianOperator
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Apply(H,psi)
    assert(#H==#psi,"Hamiltonian state dimension mismatch")
    return LA.MatrixVector(H,psi)
end
function Module.Energy(H,psi)
    local hp=LA.MatrixVector(H,psi); return LA.Dot(psi,hp)
end

return Module
