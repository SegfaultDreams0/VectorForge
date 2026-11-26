-- signal-processing implementation for AdaptiveLMS
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Update(weights,input,desired,stepSize,leakage)
    assert(#weights==#input,"LMS tap/input dimension mismatch"); Num.Positive(stepSize,"adaptation step")
    local estimate=LA.Dot(weights,input); local error=desired-estimate; local nextWeights=table.create(#weights)
    for i=1,#weights do nextWeights[i]=(1-(leakage or 0))*weights[i]+stepSize*error*input[i] end
    return nextWeights,{Estimate=estimate,Error=error}
end

return Module
