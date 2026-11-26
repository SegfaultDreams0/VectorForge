-- optimization-methods implementation for OptimizerStoppingRules
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.

local Module = {}
function Module.ShouldStop(gradientNorm,stepNorm,iteration,settings)
    return gradientNorm<=settings.GradientTolerance or stepNorm<=settings.StepTolerance or iteration>=settings.MaxIterations
end

return Module
