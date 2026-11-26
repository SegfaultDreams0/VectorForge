-- signal-processing implementation for Convolution2D
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Valid(image,kernel)
    local rows=#image; local cols=#image[1]; local kr=#kernel; local kc=#kernel[1]
    assert(rows>=kr and cols>=kc,"kernel larger than image")
    local out=LA.Zeros(rows-kr+1,cols-kc+1)
    for i=1,#out do for j=1,#out[1] do
        local sum=0; for u=1,kr do for v=1,kc do sum+=image[i+u-1][j+v-1]*kernel[kr-u+1][kc-v+1] end end; out[i][j]=sum
    end end
    return out
end

return Module
