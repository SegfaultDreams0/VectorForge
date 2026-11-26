-- signal-processing implementation for Convolution1D
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Full(x,h)
    assert(#x>0 and #h>0,"convolution inputs cannot be empty")
    local y=table.create(#x+#h-1,0)
    for i=1,#x do for j=1,#h do y[i+j-1]+=x[i]*h[j] end end
    return y
end

return Module
