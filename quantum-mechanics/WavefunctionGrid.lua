-- quantum-mechanics implementation for WavefunctionGrid
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.

local Module = {}
function Module.Uniform(minimum,maximum,count)
    assert(maximum>minimum and count>=2 and count%1==0,"invalid wavefunction grid")
    local values=table.create(count)
    for i=1,count do values[i]=minimum+(maximum-minimum)*(i-1)/(count-1) end
    return values
end

return Module
