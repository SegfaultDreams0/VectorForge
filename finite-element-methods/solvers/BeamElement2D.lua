-- finite-element-methods implementation for BeamElement2D
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Stiffness(E,I,L)
    Num.Positive(E,"Young modulus"); Num.Positive(I,"second moment"); Num.Positive(L,"length")
    local f=E*I/(L^3)
    return {{12*f,6*L*f,-12*f,6*L*f},{6*L*f,4*L*L*f,-6*L*f,2*L*L*f},{-12*f,-6*L*f,12*f,-6*L*f},{6*L*f,2*L*L*f,-6*L*f,4*L*L*f}}
end

return Module
