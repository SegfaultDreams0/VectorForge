-- quantum-mechanics implementation for Schrodinger1D
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.Hamiltonian(potential,dx,mass,hbar)
    local n=#potential; Num.Positive(dx,"grid spacing"); Num.Positive(mass,"mass"); hbar=hbar or Constants.HBAR
    local coefficient=hbar*hbar/(2*mass*dx*dx); local H=LA.Zeros(n,n)
    for i=1,n do
        H[i][i]=2*coefficient+potential[i]
        if i>1 then H[i][i-1]=-coefficient end
        if i<n then H[i][i+1]=-coefficient end
    end
    return H
end


-- Finite-difference Hamiltonian for H = -(hbar^2/2m)d^2/dx^2 + V(x).
-- Dirichlet boundary conditions are assumed; grid spacing is metres and energy is joules.
function Module.FiniteDifferenceHamiltonian(grid, potential, mass, hbar)
    Num.Positive(mass, "particle mass")
    local h = hbar or Constants.HBAR
    Num.Positive(h, "reduced Planck constant")
    assert(#grid >= 3 and #potential == #grid, "grid and potential dimensions mismatch")
    local dx = grid[2] - grid[1]
    Num.Positive(dx, "grid spacing")
    for i = 2, #grid - 1 do
        assert(math.abs((grid[i+1] - grid[i]) - dx) <= 1e-10 * dx, "uniform grid required")
    end
    local interior = #grid - 2
    local kinetic = h * h / (2 * mass * dx * dx)
    local H = LA.Zeros(interior, interior)
    for i = 1, interior do
        H[i][i] = 2 * kinetic + potential[i+1]
        if i > 1 then H[i][i-1] = -kinetic end
        if i < interior then H[i][i+1] = -kinetic end
    end
    return H, {Spacing = dx, InteriorPoints = interior, KineticCoefficient = kinetic}
end

-- Normalize a real-valued sampled state using the discrete integral sum |psi|^2 dx.
function Module.NormalizeSampledState(psi, spacing)
    Num.Positive(spacing, "grid spacing")
    local normSquared = 0
    for i = 1, #psi do normSquared += psi[i] * psi[i] * spacing end
    Num.Positive(normSquared, "wavefunction norm")
    local scale = 1 / math.sqrt(normSquared)
    local normalized = table.create(#psi)
    for i = 1, #psi do normalized[i] = psi[i] * scale end
    return normalized
end

return Module
