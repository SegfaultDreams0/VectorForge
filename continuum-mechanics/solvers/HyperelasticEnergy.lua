-- continuum-mechanics implementation for HyperelasticEnergy
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.NeoHookean(F,mu,lambda)
    Num.Positive(mu,"shear modulus"); Num.Positive(lambda,"Lamé lambda"); local J=LA.Determinant(F); Num.Positive(J,"J")
    local C=LA.Multiply(LA.Transpose(F),F); local I1=LA.Trace(C)
    return 0.5*mu*(I1-3)-mu*math.log(J)+0.5*lambda*math.log(J)^2
end

return Module
