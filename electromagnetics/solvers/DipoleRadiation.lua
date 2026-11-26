-- electromagnetics implementation for DipoleRadiation
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.FarFieldElectric(dipoleMoment,angularFrequency,distance,theta)
    Num.Nonnegative(dipoleMoment,"dipole moment"); Num.Positive(angularFrequency,"angular frequency"); Num.Positive(distance,"distance")
    return Constants.MU_0*angularFrequency^2*dipoleMoment*math.sin(theta)/(4*math.pi*distance)
end

return Module
