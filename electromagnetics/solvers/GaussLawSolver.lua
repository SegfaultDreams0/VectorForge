-- electromagnetics implementation for GaussLawSolver
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.EnclosedCharge(electricFlux)
    return Constants.EPSILON_0*electricFlux
end
function Module.SphericalField(charge,radius)
    Num.Positive(radius,"radius"); return charge/(4*math.pi*Constants.EPSILON_0*radius^2)
end

return Module
