-- constitutive model settings
local M = {}
function M.new(tolerance,maxIterations)
    assert(tolerance > 0 and maxIterations >= 1, "invalid constitutive settings")
    return {Tolerance=tolerance,MaxIterations=maxIterations,ConsistentTangent=true}
end
return M
