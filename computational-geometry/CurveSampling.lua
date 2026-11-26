-- computational-geometry implementation for CurveSampling
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.

local Module = {}
function Module.Uniform(count,minimum,maximum)
    assert(count>=2 and maximum>minimum,"invalid curve sampling range"); local samples=table.create(count)
    for i=1,count do samples[i]=minimum+(maximum-minimum)*(i-1)/(count-1) end; return samples
end

return Module
