-- electromagnetics implementation for FaradayInduction
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.EMF(turns,fluxInitial,fluxFinal,deltaTime)
    assert(turns>=1 and turns%1==0,"turn count must be a positive integer"); Num.Positive(deltaTime,"time interval")
    return -turns*(fluxFinal-fluxInitial)/deltaTime
end

return Module
