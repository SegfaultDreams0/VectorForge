-- quantum-mechanics implementation for Schrodinger2D
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ApplyLaplacian(field,dx,dy)
    Num.Positive(dx,"dx"); Num.Positive(dy,"dy"); local rows=#field; local cols=#field[1]; local out=LA.Zeros(rows,cols)
    for i=2,rows-1 do for j=2,cols-1 do
        out[i][j]=(field[i+1][j]-2*field[i][j]+field[i-1][j])/(dx*dx)+(field[i][j+1]-2*field[i][j]+field[i][j-1])/(dy*dy)
    end end
    return out
end

return Module
