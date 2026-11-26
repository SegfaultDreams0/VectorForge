-- continuum-mechanics implementation for NeoHookeanMaterial
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.CauchyStress(F,shearModulus,bulkModulus)
    Num.Positive(shearModulus,"shear modulus"); Num.Positive(bulkModulus,"bulk modulus")
    local J=LA.Determinant(F); Num.Positive(J,"deformation Jacobian")
    local B=LA.Multiply(F,LA.Transpose(F)); local scale=shearModulus/J
    local stress=Num.Scale(Num.Subtract(B,LA.Identity(3)),scale)
    local volumetric=bulkModulus*math.log(J)/J
    for i=1,3 do stress[i][i]+=volumetric end
    return stress
end
function Module.Energy(F,shearModulus,bulkModulus)
    local J=LA.Determinant(F); Num.Positive(J,"deformation Jacobian")
    local B=LA.Multiply(LA.Transpose(F),F); local I1=LA.Trace(B)
    return 0.5*shearModulus*(I1-3)-shearModulus*math.log(J)+0.5*bulkModulus*math.log(J)^2
end


-- First Piola-Kirchhoff stress for compressible neo-Hookean material:
-- P = mu(F-F^-T)+lambda ln(J) F^-T, with J=det(F)>0.
function Module.FirstPiola(deformationGradient, lameLambda, shearModulus)
    assert(lameLambda>=0 and shearModulus>0,"invalid Lamé parameters")
    local determinant=LA.Determinant(deformationGradient)
    Num.Positive(determinant,"deformation Jacobian")
    local inverseTranspose=LA.Transpose(LA.Inverse(deformationGradient))
    local logarithm=math.log(determinant)
    local elastic=LA.Scale(LA.Subtract(deformationGradient,inverseTranspose),shearModulus)
    local volumetric=LA.Scale(inverseTranspose,lameLambda*logarithm)
    return LA.Add(elastic,volumetric)
end

-- Isochoric invariant I1_bar = J^(-2/3) tr(F^T F) in three dimensions.
function Module.ModifiedFirstInvariant(deformationGradient)
    local determinant=LA.Determinant(deformationGradient)
    Num.Positive(determinant,"deformation Jacobian")
    local rightCauchyGreen=LA.Multiply(LA.Transpose(deformationGradient),deformationGradient)
    return determinant^(-2/3)*LA.Trace(rightCauchyGreen)
end

return Module
