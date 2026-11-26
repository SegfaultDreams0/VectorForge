-- finite-element-methods implementation for TriangularElement2D
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("FiniteElementMethods")
local ElasticityPlaneStrain = require(DomainModules:WaitForChild("solvers"):WaitForChild("ElasticityPlaneStrain"))
local ElasticityPlaneStress = require(DomainModules:WaitForChild("models"):WaitForChild("ElasticityPlaneStress"))

local Module = {}
function Module.CST(nodes,E,nu,thickness,planeStress)
    assert(#nodes==3,"CST triangle requires three nodes"); Num.Positive(E,"Young modulus"); Num.Positive(thickness,"thickness")
    local x1,y1=nodes[1][1],nodes[1][2]; local x2,y2=nodes[2][1],nodes[2][2]; local x3,y3=nodes[3][1],nodes[3][2]
    local twiceArea=(x2-x1)*(y3-y1)-(x3-x1)*(y2-y1); local area=math.abs(twiceArea)/2; Num.Positive(area,"triangle area")
    local b={y2-y3,y3-y1,y1-y2}; local c={x3-x2,x1-x3,x2-x1}; local B=LA.Zeros(3,6)
    for i=1,3 do B[1][2*i-1]=b[i]/twiceArea; B[2][2*i]=c[i]/twiceArea; B[3][2*i-1]=c[i]/twiceArea; B[3][2*i]=b[i]/twiceArea end
    local D=if planeStress==false then ElasticityPlaneStrain.Constitutive(E,nu) else ElasticityPlaneStress.Constitutive(E,nu)
    return Num.Scale(LA.Multiply(LA.Multiply(LA.Transpose(B),D),B),area*thickness)
end

return Module
