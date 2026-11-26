-- element integration rules
local M = {}
function M.Gauss1D(order)
    local rules = {
        [1]={{0},{2}},
        [2]={{-0.577350269189626,0.577350269189626},{1,1}},
        [3]={{-0.774596669241483,0,0.774596669241483},{0.555555555555556,0.888888888888889,0.555555555555556}}
    }
    assert(rules[order] ~= nil, "unsupported integration order")
    return rules[order][1], rules[order][2]
end
return M
