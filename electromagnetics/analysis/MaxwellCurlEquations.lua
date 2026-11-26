-- electromagnetics implementation for MaxwellCurlEquations
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Faraday(curlE,dt)
    Num.Nonnegative(dt,"time step"); return Num.Scale(curlE,-dt)
end
function Module.Ampere(curlH,currentDensity,displacementCurrent)
    return Num.Add(curlH,Num.Add(currentDensity,displacementCurrent))
end

return Module
