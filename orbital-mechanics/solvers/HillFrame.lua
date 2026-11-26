-- orbital-mechanics implementation for HillFrame
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Basis(position,velocity)
    local radial=Num.Scale(position,1/LA.Norm(position)); local normal=Num.Cross3(position,velocity); normal=Num.Scale(normal,1/LA.Norm(normal)); local along=Num.Cross3(normal,radial)
    return {Radial=radial,AlongTrack=along,CrossTrack=normal}
end
function Module.Project(vector,basis)
    return {LA.Dot(vector,basis.Radial),LA.Dot(vector,basis.AlongTrack),LA.Dot(vector,basis.CrossTrack)}
end

return Module
