-- signal-processing implementation for IIRFilter
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Biquad(samples,coefficients,state)
    local b0,b1,b2,a1,a2=coefficients.b0,coefficients.b1,coefficients.b2,coefficients.a1,coefficients.a2
    local x1=state and state.x1 or 0; local x2=state and state.x2 or 0; local y1=state and state.y1 or 0; local y2=state and state.y2 or 0
    local out=table.create(#samples)
    for i=1,#samples do
        local y=b0*samples[i]+b1*x1+b2*x2-a1*y1-a2*y2
        out[i]=y; x2=x1; x1=samples[i]; y2=y1; y1=y
    end
    return out,{x1=x1,x2=x2,y1=y1,y2=y2}
end

return Module
