-- finite-element-methods implementation for GlobalAssembly
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Assemble(elementMatrices,connectivity,nodeCount,dofPerNode)
    local size=nodeCount*dofPerNode; local global=LA.Zeros(size,size)
    assert(#elementMatrices==#connectivity,"element/connectivity count mismatch")
    for e=1,#elementMatrices do
        local map={}; for _,node in ipairs(connectivity[e]) do for d=1,dofPerNode do table.insert(map,(node-1)*dofPerNode+d) end end
        local Ke=elementMatrices[e]; assert(#Ke==#map and #Ke[1]==#map,"element stiffness size mismatch")
        for i=1,#map do for j=1,#map do global[map[i]][map[j]]+=Ke[i][j] end end
    end
    return global
end

return Module
