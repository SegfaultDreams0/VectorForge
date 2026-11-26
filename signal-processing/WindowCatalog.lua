-- signal-processing implementation for WindowCatalog
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Hamming(index,count)
    assert(count>1 and index>=1 and index<=count,"invalid Hamming window index")
    return 0.54-0.46*math.cos(2*math.pi*(index-1)/(count-1))
end
function Module.BlackmanHarris(index,count)
    assert(count>1 and index>=1 and index<=count,"invalid window index")
    local x=2*math.pi*(index-1)/(count-1)
    return 0.35875-0.48829*math.cos(x)+0.14128*math.cos(2*x)-0.01168*math.cos(3*x)
end

return Module
