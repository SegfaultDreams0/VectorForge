-- window catalog
local M = {}
function M.Hann(index,count)
    assert(count > 1 and index >= 1 and index <= count, "invalid window index")
    return 0.5*(1-math.cos(2*math.pi*(index-1)/(count-1)))
end
function M.Hamming(index,count)
    assert(count > 1 and index >= 1 and index <= count, "invalid window index")
    return 0.54-0.46*math.cos(2*math.pi*(index-1)/(count-1))
end
return M
