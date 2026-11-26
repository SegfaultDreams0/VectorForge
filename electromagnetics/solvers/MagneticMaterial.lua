-- electromagnetics implementation for MagneticMaterial
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.FieldFromFluxDensity(fluxDensity,relativePermeability)
    Num.Positive(relativePermeability,"relative permeability")
    return fluxDensity/(Constants.MU_0*relativePermeability)
end
function Module.Magnetization(B,H)
    return B/Constants.MU_0-H
end

return Module
