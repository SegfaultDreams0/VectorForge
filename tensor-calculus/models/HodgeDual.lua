-- tensor-calculus implementation for HodgeDual
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.OneForm2D(omega,metric)
    assert(#omega==2 and #metric==2,"two-dimensional one-form required")
    local determinant=LA.Determinant(metric); assert(determinant>0,"metric must be positive definite")
    local inverse=LA.Inverse(metric); local raised=LA.MatrixVector(inverse,omega); local density=math.sqrt(determinant)
    return {density*raised[2],-density*raised[1]}
end

return Module
