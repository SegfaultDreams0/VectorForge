-- electromagnetics implementation for FieldSamplingGrid
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.

local Module = {}
function Module.Axis(minimum,maximum,count)
    assert(maximum>minimum and count>=2 and count%1==0,"invalid field sampling axis")
    local axis=table.create(count); for i=1,count do axis[i]=minimum+(maximum-minimum)*(i-1)/(count-1) end; return axis
end

return Module
