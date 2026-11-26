-- curve sampling
local M = {}
function M.Uniform(count,minimum,maximum)
    assert(count >= 2 and maximum > minimum, "invalid sampling interval")
    local values=table.create(count)
    for i=1,count do values[i]=minimum+(maximum-minimum)*(i-1)/(count-1) end
    return values
end
return M
