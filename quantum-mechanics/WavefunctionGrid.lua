-- wavefunction grid
local M = {}
function M.Uniform(minimum,maximum,count)
    assert(maximum > minimum and count >= 2, "invalid wavefunction grid")
    local x=table.create(count)
    for i=1,count do x[i]=minimum+(maximum-minimum)*(i-1)/(count-1) end
    return x
end
return M
