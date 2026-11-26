-- finite-element-methods implementation for HexahedralElement3D
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.ShapeFunction(xi,eta,zeta)
    local signs={{-1,-1,-1},{1,-1,-1},{1,1,-1},{-1,1,-1},{-1,-1,1},{1,-1,1},{1,1,1},{-1,1,1}}
    local N=table.create(8)
    for i=1,8 do N[i]=0.125*(1+signs[i][1]*xi)*(1+signs[i][2]*eta)*(1+signs[i][3]*zeta) end
    return N
end
function Module.NaturalDerivatives(xi,eta,zeta)
    local signs={{-1,-1,-1},{1,-1,-1},{1,1,-1},{-1,1,-1},{-1,-1,1},{1,-1,1},{1,1,1},{-1,1,1}}
    local D=LA.Zeros(8,3)
    for i=1,8 do local sx,sy,sz=signs[i][1],signs[i][2],signs[i][3]; D[i][1]=sx*(1+sy*eta)*(1+sz*zeta)/8; D[i][2]=sy*(1+sx*xi)*(1+sz*zeta)/8; D[i][3]=sz*(1+sx*xi)*(1+sy*eta)/8 end
    return D
end

return Module
