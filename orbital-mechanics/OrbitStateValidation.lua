-- orbital-mechanics implementation for OrbitStateValidation
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Validate(position,velocity)
    assert(#position==3 and #velocity==3,"orbit state vectors must have three elements")
    assert(LA.Norm(position)>0,"position cannot be zero")
    for i=1,3 do assert(position[i]==position[i] and velocity[i]==velocity[i] and math.abs(position[i])<math.huge and math.abs(velocity[i])<math.huge,"state contains non-finite values") end
    return true
end

return Module
