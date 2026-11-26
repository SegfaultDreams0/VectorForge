-- geometric tolerance
local M = {}
function M.ForScale(scale,relative)
    assert(scale >= 0, "scale must be nonnegative")
    return math.max(1e-12,scale*(relative or 1e-9))
end
function M.IsNear(a,b,tolerance)
    return math.abs(a-b) <= tolerance
end
return M
