-- signal-processing implementation for FIRFilter
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Apply(taps,samples,initialState)
    local history=initialState or table.create(#taps-1,0); local output=table.create(#samples)
    for n=1,#samples do
        local window={samples[n]}
        for j=1,#taps-1 do table.insert(window,history[j] or 0) end
        local y=0; for j=1,#taps do y+=taps[j]*window[j] end
        output[n]=y
        for j=#history,2,-1 do history[j]=history[j-1] end
        if #history>0 then history[1]=samples[n] end
    end
    return output,history
end

return Module
