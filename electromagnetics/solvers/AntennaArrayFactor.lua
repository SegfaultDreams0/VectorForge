-- electromagnetics implementation for AntennaArrayFactor
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Linear(weights,spacing,wavelength,angle)
    Num.Positive(wavelength,"wavelength"); Num.Nonnegative(spacing,"element spacing")
    local sum={Re=0,Im=0}; local phaseStep=2*math.pi*spacing*math.cos(angle)/wavelength
    for i=1,#weights do sum=Num.ComplexAdd(sum,Num.ComplexScale(Num.ComplexExp((i-1)*phaseStep),weights[i])) end
    return {Real=sum.Re,Imaginary=sum.Im,Magnitude=math.sqrt(Num.ComplexAbs2(sum))}
end

return Module
