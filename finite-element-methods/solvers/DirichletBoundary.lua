-- finite-element-methods implementation for DirichletBoundary
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Apply(Kglobal,load,dof,value)
    assert(dof>=1 and dof<=#load,"constrained DOF out of range")
    local matrix=LA.Copy(Kglobal); local rhs=table.clone(load)
    for i=1,#matrix do if i~=dof then rhs[i]-=matrix[i][dof]*value; matrix[i][dof]=0; matrix[dof][i]=0 end end
    matrix[dof][dof]=1; rhs[dof]=value
    return matrix,rhs
end

return Module
