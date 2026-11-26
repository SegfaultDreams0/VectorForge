-- tensor-calculus implementation for ScalarCurvature
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.

local Module = {}
function Module.Contract(inverseMetric,ricci)
    assert(#inverseMetric==#ricci,"metric and Ricci dimensions mismatch")
    local scalar=0
    for i=1,#ricci do for j=1,#ricci do scalar+=inverseMetric[i][j]*ricci[i][j] end end
    return scalar
end

return Module
