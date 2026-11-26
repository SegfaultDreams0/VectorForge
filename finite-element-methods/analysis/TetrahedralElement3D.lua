-- finite-element-methods implementation for TetrahedralElement3D
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Geometry(nodes)
    assert(#nodes==4,"tetrahedron requires four nodes")
    local J=LA.Zeros(3,3)
    for i=1,3 do for j=1,3 do J[i][j]=nodes[j+1][i]-nodes[1][i] end end
    local determinant=Num.Det3(J); local volume=math.abs(determinant)/6
    Num.Positive(volume,"tetrahedron volume")
    local inverse=LA.Inverse(J); assert(inverse,"degenerate tetrahedron")
    local gradients={{-1,-1,-1}}
    for node=2,4 do gradients[node]=table.create(3); for axis=1,3 do gradients[node][axis]=inverse[node-1][axis] end end
    gradients[1]={-(gradients[2][1]+gradients[3][1]+gradients[4][1]),-(gradients[2][2]+gradients[3][2]+gradients[4][2]),-(gradients[2][3]+gradients[3][3]+gradients[4][3])}
    return {Volume=volume,ShapeGradients=gradients,Jacobian=J}
end

return Module
