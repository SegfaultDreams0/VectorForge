-- tensor metric data
local M = {}
function M.Determinant2(g)
    assert(#g == 2 and #g[1] == 2 and #g[2] == 2, "expected a two dimensional metric")
    return g[1][1]*g[2][2]-g[1][2]*g[2][1]
end
function M.Trace(g)
    local total=0
    for i=1,#g do total += g[i][i] end
    return total
end
return M
