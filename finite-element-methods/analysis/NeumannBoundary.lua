-- finite-element-methods implementation for NeumannBoundary
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.LinearEdgeLoad(flux,length)
    Num.Positive(length,"edge length")
    return {flux*length/2,flux*length/2}
end

return Module
