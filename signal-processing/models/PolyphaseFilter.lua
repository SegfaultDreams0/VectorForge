-- signal-processing implementation for PolyphaseFilter
-- Assumptions: samples are uniformly spaced unless the method accepts explicit timestamps; amplitudes are unit-preserving and frequency units follow the supplied sample rate.

local Module = {}
function Module.Split(taps,phases)
    assert(phases>=1 and phases%1==0,"phase count must be positive")
    local bank=table.create(phases)
    for p=1,phases do bank[p]={}; for i=p,#taps,phases do table.insert(bank[p],taps[i]) end end
    return bank
end

return Module
