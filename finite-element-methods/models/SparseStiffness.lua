-- finite-element-methods implementation for SparseStiffness
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.FromTriplets(rows,columns,triplets)
    local sparse=LA.SparseMatrix.new(rows,columns)
    for _,entry in ipairs(triplets) do sparse:Set(entry.Row,entry.Column,sparse:Get(entry.Row,entry.Column)+entry.Value) end
    return sparse
end

return Module
