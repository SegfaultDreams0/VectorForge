-- optimizer stopping rules
local M = {}
function M.new(gradientTolerance,stepTolerance,maxIterations)
    assert(gradientTolerance > 0 and stepTolerance > 0 and maxIterations >= 1, "invalid stopping rules")
    return {GradientTolerance=gradientTolerance,StepTolerance=stepTolerance,MaxIterations=maxIterations}
end
function M.ShouldStop(gradientNorm,stepNorm,iteration,settings)
    return gradientNorm <= settings.GradientTolerance or stepNorm <= settings.StepTolerance or iteration >= settings.MaxIterations
end
return M
