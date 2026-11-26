-- orbital-mechanics implementation for GroundTrack
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Longitude(inertialLongitude,time,earthRotationRate)
    Num.Nonnegative(time,"time"); return ((inertialLongitude-earthRotationRate*time+math.pi)%(2*math.pi))-math.pi
end
function Module.Latitude(position)
    Num.Positive(LA.Norm(position),"radius"); return math.asin(position[3]/LA.Norm(position))
end

return Module
