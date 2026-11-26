-- signal-processing implementation for WaveletPacket
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.HaarLevel(samples)
    assert(#samples%2==0,"Haar packet input length must be even")
    local low,high=table.create(#samples/2),table.create(#samples/2); local inv=1/math.sqrt(2)
    for i=1,#samples,2 do local k=(i+1)/2; low[k]=(samples[i]+samples[i+1])*inv; high[k]=(samples[i]-samples[i+1])*inv end
    return low,high
end
function Module.Decompose(samples,levels)
    local packet={}; local current=table.clone(samples)
    for level=1,levels do
        local low,high=Module.HaarLevel(current); packet[level]={Approximation=low,Detail=high}; current=low
    end
    return packet
end

return Module
