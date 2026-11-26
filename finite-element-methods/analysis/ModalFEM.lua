-- finite-element-methods implementation for ModalFEM
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Solve(Kglobal,Mglobal,iterations,tolerance)
    assert(#Kglobal==#Mglobal and #Kglobal[1]==#Mglobal[1],"mass and stiffness matrices must be square and equal-sized")
    local L,reason=LA.Cholesky(Mglobal); assert(L,reason or "mass matrix is not positive definite")
    local Linv,why=LA.Inverse(L); assert(Linv,why or "mass Cholesky factor is singular")
    local transformed=LA.Multiply(Linv,LA.Multiply(Kglobal,LA.Transpose(Linv)))
    local sym=Num.Scale(Num.Add(transformed,LA.Transpose(transformed)),0.5)
    local values,vectors=LA.SymmetricEigen(sym,iterations,tolerance)
    local frequencies=table.create(#values)
    for i=1,#values do assert(values[i]>=-1e-9,"negative generalized eigenvalue"); frequencies[i]=math.sqrt(math.max(values[i],0)) end
    return frequencies,vectors
end

return Module
