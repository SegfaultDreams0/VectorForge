-- field sampling grid
local M = {}
function M.Axis(minimum,maximum,count)
    assert(maximum > minimum and count >= 2, "invalid field axis")
    local out=table.create(count)
    for i=1,count do out[i]=minimum+(maximum-minimum)*(i-1)/(count-1) end
    return out
end
return M
