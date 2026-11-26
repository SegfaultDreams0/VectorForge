-- finite-element-methods implementation for BeamElement3D
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.LocalStiffness(E,G,A,Iy,Iz,J,L)
    Num.Positive(E,"Young modulus"); Num.Positive(G,"shear modulus"); Num.Positive(A,"area"); Num.Positive(L,"length")
    local k=LA.Zeros(12,12); local EA=E*A/L; local GJ=G*J/L
    k[1][1]=EA; k[1][7]=-EA; k[7][1]=-EA; k[7][7]=EA
    k[4][4]=GJ; k[4][10]=-GJ; k[10][4]=-GJ; k[10][10]=GJ
    local a=12*E*Iz/L^3; local b=6*E*Iz/L^2; local c=4*E*Iz/L; local d=2*E*Iz/L
    local ids={2,6,8,12}; local block={{a,b,-a,b},{b,c,-b,d},{-a,-b,a,-b},{b,d,-b,c}}
    for i=1,4 do for j=1,4 do k[ids[i]][ids[j]]=block[i][j] end end
    local a2=12*E*Iy/L^3; local b2=6*E*Iy/L^2; local c2=4*E*Iy/L; local d2=2*E*Iy/L
    local ids2={3,5,9,11}; local block2={{a2,-b2,-a2,-b2},{-b2,c2,b2,d2},{-a2,b2,a2,b2},{-b2,d2,b2,c2}}
    for i=1,4 do for j=1,4 do k[ids2[i]][ids2[j]]=block2[i][j] end end
    return k
end

return Module
