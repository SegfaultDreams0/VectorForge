-- objective adapter
local M = {}
function M.Evaluate(objective,point)
    local value=objective(table.clone(point))
    assert(type(value) == "number" and value == value and math.abs(value) < math.huge, "objective returned invalid value")
    return value
end
return M
