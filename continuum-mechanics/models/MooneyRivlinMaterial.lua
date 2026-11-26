-- continuum-mechanics implementation for MooneyRivlinMaterial
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Energy(F,C1,C2,Kbulk)
    Num.Nonnegative(C1,"C1"); Num.Nonnegative(C2,"C2"); Num.Positive(Kbulk,"bulk modulus")
    local C=LA.Multiply(LA.Transpose(F),F); local J=LA.Determinant(F); Num.Positive(J,"deformation Jacobian")
    local I1=LA.Trace(C); local C2mat=LA.Multiply(C,C); local I2=0.5*(I1*I1-LA.Trace(C2mat))
    return C1*(I1-3)+C2*(I2-3)+0.5*Kbulk*math.log(J)^2
end

return Module
