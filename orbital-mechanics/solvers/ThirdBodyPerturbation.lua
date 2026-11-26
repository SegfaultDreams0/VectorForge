-- orbital-mechanics implementation for ThirdBodyPerturbation
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Acceleration(position,thirdBodyPosition,thirdBodyMu)
    Num.Positive(thirdBodyMu,"third-body gravitational parameter")
    local relative=Num.Subtract(thirdBodyPosition,position); local d=LA.Norm(relative); local R=LA.Norm(thirdBodyPosition)
    Num.Positive(d,"spacecraft to third-body distance"); Num.Positive(R,"central body to third-body distance")
    return Num.Scale(Num.Subtract(Num.Scale(relative,1/d^3),Num.Scale(thirdBodyPosition,1/R^3)),thirdBodyMu)
end

return Module
