-- optimization-methods implementation for ObjectiveAdapter
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.

local Module = {}
function Module.Evaluate(objective,point)
    local value=objective(table.clone(point)); assert(type(value)=="number" and value==value and math.abs(value)<math.huge,"objective returned non-finite scalar"); return value
end

return Module
