-- electromagnetics implementation for DielectricBoundary
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.NormalDisplacement(epsilon1,epsilon2,E1normal)
    Num.Positive(epsilon1,"epsilon1"); Num.Positive(epsilon2,"epsilon2")
    local D=epsilon1*E1normal
    return {DNormal=D,SecondNormalField=D/epsilon2}
end
function Module.NormalIncidenceReflection(n1,n2)
    Num.Positive(n1,"refractive index 1"); Num.Positive(n2,"refractive index 2")
    local amplitude=(n1-n2)/(n1+n2); return amplitude*amplitude
end

return Module
