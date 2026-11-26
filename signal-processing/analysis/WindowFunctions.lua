-- signal-processing implementation for WindowFunctions
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Hann(index,count)
    assert(count>1 and index>=1 and index<=count,"invalid Hann window index")
    return 0.5*(1-math.cos(2*math.pi*(index-1)/(count-1)))
end
function Module.Blackman(index,count)
    assert(count>1 and index>=1 and index<=count,"invalid Blackman window index")
    local phase=2*math.pi*(index-1)/(count-1)
    return 0.42-0.5*math.cos(phase)+0.08*math.cos(2*phase)
end

return Module
