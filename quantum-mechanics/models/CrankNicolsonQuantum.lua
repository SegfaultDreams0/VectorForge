-- quantum-mechanics implementation for CrankNicolsonQuantum
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.Step(H,psi,dt,hbar)
    local n=#psi; hbar=hbar or Constants.HBAR; Num.Positive(hbar,"reduced Planck constant"); Num.Nonnegative(dt,"time step")
    assert(#H==n,"Hamiltonian dimension mismatch")
    local A=LA.Identity(2*n); local B=LA.Identity(2*n)
    for i=1,n do for j=1,n do
        local x=dt*H[i][j]/(2*hbar)
        A[i][n+j]-=x; A[n+i][j]+=x
        B[i][n+j]+=x; B[n+i][j]-=x
    end end
    local rhs=table.create(2*n)
    for i=1,n do rhs[i]=psi[i].Re; rhs[n+i]=psi[i].Im end
    local target=LA.MatrixVector(B,rhs); local nextState,reason=LA.Solve(A,target)
    assert(nextState,reason or "Crank-Nicolson linear solve failed")
    local out=table.create(n)
    for i=1,n do out[i]={Re=nextState[i],Im=nextState[n+i]} end
    return out
end

return Module
