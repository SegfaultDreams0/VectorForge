-- signal-processing implementation for PhaseUnwrap
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Unwrap(phases)
    local out=table.create(#phases); if #phases==0 then return out end
    out[1]=phases[1]; local offset=0
    for i=2,#phases do
        local delta=phases[i]-phases[i-1]
        if delta>math.pi then offset-=2*math.pi elseif delta< -math.pi then offset+=2*math.pi end
        out[i]=phases[i]+offset
    end
    return out
end

return Module
