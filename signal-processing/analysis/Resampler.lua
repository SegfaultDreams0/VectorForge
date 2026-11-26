-- signal-processing implementation for Resampler
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Linear(samples,outputCount)
    assert(#samples>=2 and outputCount>=2 and outputCount%1==0,"invalid resampling sizes")
    local out=table.create(outputCount); local ratio=(#samples-1)/(outputCount-1)
    for i=0,outputCount-1 do
        local position=i*ratio; local left=math.floor(position)+1; local right=math.min(left+1,#samples); local alpha=position-math.floor(position)
        out[i+1]=samples[left]*(1-alpha)+samples[right]*alpha
    end
    return out
end

return Module
